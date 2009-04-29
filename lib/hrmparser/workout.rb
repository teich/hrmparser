module HRMParser
  class Workout
    attr_accessor :duration, :distance, :time, :name, :file_name, :trackpoints
    attr_reader :average_hr, :data, :average_speed
    
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
      @average_hr = heart_rates.compact.average
    end
    
    def calc_average_speed! 
      @average_speed = speeds.compact.average
    end
    
    
    ## Some helper functions that return specific files from trackpoint as array
    def heart_rates
      @trackpoints.map {|tp| tp.hr }
    end
    
    def speeds
      @trackpoints.map {|tp| tp.speed }
    end
  end
end