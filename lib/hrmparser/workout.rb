module HRMParser
	class Workout
		attr_accessor :duration, :distance, :time, :name, :file_name, :trackpoints
		attr_reader :average_hr, :data, :average_speed, :altitude_gain

		def initialize(opts = {:duration => nil, :distance => nil, :time => Time.now, :name => nil, :file_name => nil})
			@duration = opts[:duration]
			@name = opts[:name]
			@time = opts[:time]
			@distance = opts[:distance]
			@file_name = opts[:file_name]

			@data = nil
			@trackpoints = {}
		end


		def calc_average_hr!
			ahr = heart_rates.compact.aaverage
			@average_hr = ahr == 0.0 ? nil : ahr
		end

		def calc_average_speed! 
			aspeed = speeds.compact.aaverage
			@average_speed = aspeed == 0.0 ? nil : aspeed
		end

		def calc_altitude_gain!
			gain = 0
			smoothed_altitude = altitudes.compact.smoothed(10)
			start = smoothed_altitude.first
			smoothed_altitude.each do |alt|
				diff = alt - start
				if (diff > 0.5)
					gain += diff
				end
				start = alt
			end
			@altitude_gain = gain == 0.0 ? nil : gain

		end


		## Some helper functions that return specific files from trackpoint as array
		def heart_rates
			@trackpoints.map {|tp| tp.hr }
		end

		def speeds
			@trackpoints.map {|tp| tp.speed }
		end

		def altitudes
			@trackpoints.map { |tp| tp.altitude }
		end 
		
		def set_distance_from_trackpoints!
			@trackpoints.reverse_each do |tp|
				if !tp.distance.nil?
					self.distance = tp.distance
					break
				end
			end	
		end
	end
end