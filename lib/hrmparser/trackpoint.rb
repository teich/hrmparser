module HRMParser
  class TrackPoint
    attr_accessor :lat, :lng, :altitude, :speed, :hr, :distance, :time, :cadence
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
  end
end