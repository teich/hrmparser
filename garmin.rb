require 'hpricot'
require 'time'

class HRMImporter::Garmin

  ## GARMIN times are all in UTC
  attr_reader :parsed_workout

  def initialize(xml_string, params = {}, time_zone = "UTC")
    @xml = Hpricot::XML(xml_string)
    @parsed_workout = params
    @time_zone = time_zone
  end

  def get_workout

    time = 0.0
    (@xml/:Lap).each do |lap|
      f_time =  (lap/:TotalTimeSeconds).innerHTML
      time += Float f_time

      # TODO- "DistanceMeters" is matching both in the Lap and trackpoint.
    end

    @parsed_workout['duration'] = time
    @parsed_workout['start_time'] = (@xml/:Id).innerHTML
    return @parsed_workout
  end

  def get_trackpoints
    trackpoints = Array.new

    (@xml/:Trackpoint).each do |t| 

      trackpoint = Hash.new
      next if ((t/:HeartRateBpm/:Value).innerHTML == "")
      trackpoint["heart_rate"] = (t/:HeartRateBpm/:Value).innerHTML
      trackpoint["lat"] = (t/:Position/:LatitudeDegrees).innerHTML
      trackpoint["lng"] = (t/:Position/:LongitudeDegrees).innerHTML
      trackpoint["time"] = (t/:Time).innerHTML
      trackpoint["altitude"] = (t/:AltitudeMeters).innerHTML
      trackpoint["distance"] = (t/:DistanceMeters).innerHTML


      trackpoints << trackpoint
    end 
    return trackpoints
  end

  # (doc/:Lap).each do |l|
  #       lap = Hash.new
  #       lap["duration"] = (l/:TotalTimeSeconds).innerHTML
  #       lap["distance"] = (l/:DistanceMeters).innerHTML
  #       lap["calories"] = (l/:Calories).innerHTML
  #       lap["average_hr"] = (l/:AverageHeartRateBpm/:Value).innerHTML
  #       lap["max_hr"] = (l/:MaximumHeartRateBpm/:Value).innerHTML

end