module HRMParser
  class TrackPoint
    attr_accessor :lat, :lng, :altitude, :speed, :hr, :distance, :time
    def initialize(opts = {:lat => nil, :lng => nil, :altitude => nil, :speed => nil, :hr => nil, :distance => nil, :time => Time.now})
      @lat = opts[:lat]
      @lng = opts[:lng]
      @altitude = opts[:altitude]
      @speed = opts[:speed]
      @hr = opts[:hr]
      @distance = opts[:distance]
      @time = opts[:time]      
    end
  end
end