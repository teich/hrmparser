module Importer
	class Suunto
		attr_reader :time_zone

		def initialize(opts = {:data => nil, :time_zone => "UTC"})
			@data = opts[:data]
			@time_zone = opts[:time_zone]
		end

		def restore
			workout = HRMParser::Workout.new(:duration => 0)

			params = parse_params("HEADER")

			# Using DateTime because 1.8 at leas doesn't have a Time.strptime
			# And european ordeirng consfuses time.parse
			# TODO: must be some better way
			dt = DateTime.strptime(params["STARTTIME"], "%d.%m.%Y %H:%M.%S")
			time_for_parse = dt.strftime("%b %d %H:%M:%S @time_zone %Y")

			workout.time = Time.parse(time_for_parse)
			workout.duration = params["DURATION"].to_f

			workout.trackpoints = get_trackpoints

			workout.calc_average_hr!
			workout.calc_altitude_gain!
			workout.calc_average_speed! 
			workout.set_distance_from_trackpoints!

			return workout
		end

		private 

		def parse_params(string)
			hash = {}
			param_block = find_block(string)
			param_block.each do |param|
				# /=/ in case that doesn't work
				key, value = param.split("=", 2)
				key = key.strip unless key.nil?
				value = value.strip unless value.nil?
				hash[key] = value unless key.nil?
			end
			return hash
		end

		def find_block(header)
			found = false
			block = []
			@data.each do |line|
				line.chomp!
				found = false if line =~ /^\[.*\]$/
				block << line if found
				found = true if line =~ /\[#{header}\]/
			end
			return block
		end

		def parse_data(string)
			data = []
			block_text = find_block(string)
			block_text.each do |block_line|
				data << block_line.chomp
			end
			return data
		end

		def get_trackpoints
			trackpoints = []
			logs = parse_data("POINTS")
			for line in logs do
				type, date, time, altitude, blank, blank, hr, epoc, respiration, ventilation, vo2, kcal, blank, blank, distance, speed, cadence, temp = line.split(/,/)
				next if type == "\"T6LAP\""

				trackpoint = HRMParser::TrackPoint.new

				points_f = %w[epoc kcal speed]
				points_i = %w[altitude hr respiration ventilation vo2 distance cadence temp]

				points_f.each { |p| trackpoint.send("#{p}=".to_sym, (eval p).to_f) }
				points_i.each { |p| trackpoint.send("#{p}=".to_sym, (eval p).to_i) }

				dt = DateTime.strptime(date + " " + time, "%d.%m.%Y %H:%M.%S")
				time_for_parse = dt.strftime("%b %d %H:%M:%S @time_zone %Y")
				trackpoint.time = Time.parse(time_for_parse)

				trackpoints << trackpoint
			end
			return trackpoints
		end
	end
end
