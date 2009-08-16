module Importer
	class Timex
		attr_reader :time_zone

		def initialize(opts = {:data => nil, :time_zone => "UTC"})
			@data = opts[:data]
			@time_zone = opts[:time_zone]
		end
		
		def restore
		  workout = HRMParser::Workout.new(:duration => 0)
		  
		  params = parse_params("session data")
		  
		  dt = DateTime.strptime(params["Sessiondate"], "%d/%m/%Y %H:%M:%S")
			time_for_parse = dt.strftime("%b %d %H:%M:%S @time_zone %Y")

			workout.time = Time.parse(time_for_parse)
			workout.duration = params["duration"].to_f
			
      workout.trackpoints = get_trackpoints(workout.time)

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
		
		def get_trackpoints(base_time)
			trackpoints = []
			have_gps = false
			logs = parse_data("recorded")
      fields = logs[0].split(/,/)
      have_gps = true if fields.size > 5
      
  		for line in logs do
  		  if have_gps
		      if line =~ /^".*"/ then line.gsub!(/"(.*?)"/,'\1') end  # remove double-quotes at string beginning & end
          seconds, hr, speed_imperial, distance_imperial, data_flag, lng, lat, altitude, acqs, trueh, magh = line.split(/,/)
		    else
		      seconds, hr, speed_imperial, distance_imperial, data_flag = line.split(/,/)
	      end
	      
	      
	      ## Convert speed and distance to metric - meters specifically
	      distance = distance_imperial.to_f * 1609.344
	      speed = speed_imperial.to_f * 0.44704
	      
	      
				trackpoint = HRMParser::TrackPoint.new

				points_f = %w[speed distance lat lng altitude]
				points_i = %w[hr]

        
				points_f.each do |p|
					value = (eval p).to_f
					value = nil if value == 0.0
					trackpoint.send("#{p}=".to_sym, value)
				end
				
				points_i.each do |p| 
					value = (eval p).to_i
					value = nil if value == 0
					trackpoint.send("#{p}=".to_sym, value)
				end
				
				trackpoint.time = base_time + seconds.to_i

				trackpoints << trackpoint
			end
			return trackpoints
		end
		
		
		
	end
end