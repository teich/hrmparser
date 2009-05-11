module Importer
	class GPX
		def initialize(opts = {:data => nil, :time_zone => "UTC"})
			@data = opts[:data]
		end

		def restore
			workout = HRMParser::Workout.new(:duration => 0)
			@xml = Hpricot::XML(@data)

			# Set the time based on first trackpoint.  Seen an instance where the gpx begining time is wrong
			ttime = (@xml/:trk/:trkpt/:time).first.innerHTML
			workout.time = Time.parse(ttime)

			trackpoints = []
			distance = 0
			(@xml/:trk).each do |trk|
				(trk/:trkpt).each do |trkpt|
					trackpoint = HRMParser::TrackPoint.new
					trackpoint.altitude = (trkpt/:ele).innerHTML.to_f
					trackpoint.time = Time.parse((trkpt/:time).innerHTML)

					trackpoint.lat = (trkpt.attributes)["lat"].to_f
					trackpoint.lng = (trkpt.attributes)["lon"].to_f

					distance += trackpoint.calc_distance(trackpoints.last, trackpoint)
					trackpoint.distance = distance

					trackpoint.speed = trackpoint.calc_speed(trackpoints.last, trackpoint)

					trackpoints << trackpoint
				end
			end

			workout.duration = trackpoints.last.time - trackpoints.first.time
			workout.trackpoints = trackpoints
			workout.calc_average_speed! 
			workout.calc_altitude_gain!
			workout.distance = trackpoints.last.distance
			return workout
		end
	end

end