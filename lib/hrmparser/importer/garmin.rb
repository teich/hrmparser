module Importer
	class Garmin
		def initialize(opts = {:data => nil})
			@data = opts[:data]
		end

		def restore
			workout = HRMParser::Workout.new(:duration => 0)
			#data = Importer.read_in_file(@file_name)

			@xml = Hpricot::XML(@data)
			workout.time = Time.parse((@xml/:Id).innerHTML)

			(@xml/:Lap).each do |lap|
				f_time =  (lap/:TotalTimeSeconds).innerHTML
				workout.duration += Float f_time
			end

			found = false
			trackpoints = Array.new
			distance_one = nil
			time_one = nil

			(@xml/:Trackpoint).each do |t| 
				found = true
				trackpoint = HRMParser::TrackPoint.new

				trackpoint.time = Time.parse((t/:Time).innerHTML)

				hr = (t/:HeartRateBpm/:Value).innerHTML
				alt = (t/:AltitudeMeters).innerHTML
				dis = (t/:DistanceMeters).innerHTML

				trackpoint.hr =       hr != "" ? hr.to_i : nil
				trackpoint.altitude = alt != "" ? alt.to_f : nil
				trackpoint.distance = dis != "" ? dis.to_f : nil

				(t/:Position).each do |p|
					trackpoint.lat = (p/:LatitudeDegrees).innerHTML
					trackpoint.lng = (p/:LongitudeDegrees).innerHTML
				end

				trackpoints << trackpoint


				## CALCULATE SPEED.  ICK.
				if distance_one.nil?
					distance_one = trackpoint.distance
					time_one = trackpoint.time
				else
					distance_two = trackpoint.distance
					next if distance_two.nil?
					time_two = trackpoint.time
					time_delta = time_two - time_one
					distance_delta = distance_two - distance_one
					if (distance_delta > 0 && time_delta > 0)
						trackpoint.speed = distance_delta / time_delta  
						distance_one = distance_two
						time_one = time_two
					else 
						trackpoint.speed = nil
					end      
				end
			end 

			if found
				workout.trackpoints = trackpoints
				workout.calc_average_speed! 
				workout.calc_altitude_gain!
				workout.calc_average_hr!
				workout.set_distance_from_trackpoints!
			end

			return workout
		end

	end
end