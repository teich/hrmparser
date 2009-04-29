module Importer
  class Garmin
    def initialize(opts = {:file_name => nil})
      @file_name = opts[:file_name]
    end
    
    def restore
      workout = HRMParser::Workout.new
      data = Importer.read_in_file(@file_name)
      @xml = Hpricot::XML(data)
      workout.time = (@xml/:Id).innerHTML
      workout.duration = 0.0
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
        next if ((t/:HeartRateBpm/:Value).innerHTML == "")
        trackpoint.hr = (t/:HeartRateBpm/:Value).innerHTML.to_i
        trackpoint.lat = (t/:Position/:LatitudeDegrees).innerHTML.to_f
        trackpoint.lng = (t/:Position/:LongitudeDegrees).innerHTML.to_f
        trackpoint.time = Time.parse((t/:Time).innerHTML)
        trackpoint.altitude = (t/:AltitudeMeters).innerHTML.to_f
        trackpoint.distance = (t/:DistanceMeters).innerHTML.to_f
        trackpoints << trackpoint
        
    
        if distance_one.nil?
          distance_one = trackpoint.distance
          time_one = trackpoint.time
        else
          distance_two = trackpoint.distance
          time_two = trackpoint.time
          time_delta = time_two - time_one
          distance_delta = distance_two - distance_one
          if (distance_delta > 0 && time_delta > 0)
            trackpoint.speed = distance_delta / time_delta  
            distance_one = distance_two
            time_one = time_two
          else trackpoint.speed = nil
          end      
        end
      end 
      
      if found
        workout.trackpoints = trackpoints
        workout.distance = trackpoints.last.distance if !trackpoints.last.distance.nil?
        workout.calc_average_speed! 
        # workout.elevation_gain = @workout.calc_elevation_gain
        workout.calc_average_hr!
      end

      return workout
    end
    
  end
end