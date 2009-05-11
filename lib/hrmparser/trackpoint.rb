module HRMParser
	class TrackPoint

		RAD_PER_DEG = 0.017453293  #  PI/180  

		attr_accessor :lat, :lng, :altitude, :speed, :hr, :distance, :time, :cadence, :temp, :kcal, :epoc, :respiration, :ventilation, :vo2, :cadence

		def initialize(opts = {:lat => nil, :lng => nil, :altitude => nil, :speed => nil, :hr => nil, :distance => nil, :cadence => nil, :time => Time.now})
			@lat = opts[:lat]
			@lng = opts[:lng]
			@altitude = opts[:altitude]
			@speed = opts[:speed]
			@hr = opts[:hr]
			@distance = opts[:distance]
			@time = opts[:time]
			@cadence = opts[:cadence]    
		end

		def calc_distance(pointA, pointB)
			return 0 if pointA.nil? || pointA.lat.nil?

			dlng = pointB.lng - pointA.lng  
			dlat = pointB.lat - pointA.lat  

			dlat_rad = dlat * RAD_PER_DEG  
			dlng_rad = dlng * RAD_PER_DEG   

			lat1_rad = pointA.lat * RAD_PER_DEG  
			lng1_rad = pointA.lng * RAD_PER_DEG  

			lat2_rad = pointB.lat * RAD_PER_DEG  
			lng2_rad = pointB.lng * RAD_PER_DEG

			a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlng_rad/2))**2  
			c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

			return 6371000 * c
		end

		def calc_speed(pointA, pointB)
			return 0 if pointA.nil? || pointA.lat.nil?
			time_delta = pointB.time - pointA.time
			distance_delta = pointB.distance - pointA.distance
			return distance_delta / time_delta
		end
	end
end


