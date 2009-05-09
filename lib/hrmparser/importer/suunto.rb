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
			dt = DateTime.strptime(params["STARTTIME"] + " " + @time_zone, "%d.%m.%Y %H:%M.%S %Z")
			workout.time = Time.parse(dt.to_s)
			workout.duration = params["DURATION"].to_f
			
			workout.trackpoints = get_trackpoints
			
			workout.calc_average_hr!
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
				type, date, time, altitude, blank, blank, hr, epoc, respiration, ventilation, vo2, kcal, blank, blank, blank, blank, blank, temp = line.split(/,/)
				next if type == "\"T6LAP\""
				
				trackpoint = HRMParser::TrackPoint.new
				
				dt = DateTime.strptime(date + " " + time + " " + @time_zone, "%d.%m.%Y %H:%M.%S %Z")
		        trackpoint.time = Time.parse(dt.to_s)
				trackpoint.hr = hr.to_i
				
				trackpoints << trackpoint
			end
			return trackpoints
		end
	end
end
