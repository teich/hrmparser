module Importer
  class Polar
    
    attr_reader :time_zone
    
    def initialize(opts = {:data => nil, :time_zone => "UTC"})
      @data = opts[:data]
      @time_zone = opts[:time_zone]
    end      
    
    def restore
      workout = HRMParser::Workout.new(:duration => 0)
      
      params = parse_params

      date = params["Date"] + " " + params["StartTime"] + " " + @time_zone

      length_array = params["Length"].split(/:/)
      workout.duration = (length_array[0].to_f * 3600) + (length_array[1].to_f * 60) + (length_array[2].to_f)
      workout.time = Time.parse(date)
      
      workout.trackpoints = get_trackpoints(workout.time, params["Interval"].to_i)
      
      workout.calc_average_hr!

      return workout
    end
    
    
    
    private
    
    # def parse_tabbed_blocks
    #   # This is the list of tabbed blocks
    #   tabbed_blocks = %w[IntTimes ExtraData Sumary-123 Summary-TH]
    #   tabbed_blocks.each do |block_name|
    #     @polarHash[block_name] = []
    #     block_text = find_block(block_name)
    #     block_text.each do |block_line|
    #       @polarHash[block_name] << block_line.split(/\t/)
    #     end
    #   end
    # end

    # Params is the only "ini" style block
    def parse_params
      hash = {}
      param_block = find_block("Params")
      param_block.each do |param|
        # /=/ in case that doesn't work
        key, value = param.split("=", 2)
        key = key.strip unless key.nil?
        value = value.strip unless value.nil?
        hash[key] = value unless key.nil?
      end
      return hash
    end

    # Polar file has [Foo] blocks.  Return the data in the block
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
    
    def parse_hrdata
      hrdata = []
      block_text = find_block("HRData")
      block_text.each do |block_line|
        hrdata << block_line.chomp
      end
      return hrdata
    end
    
    def get_trackpoints(start_time, interval)
      trackpoints = []
      rrcounter = 0
      
      hrdata = parse_hrdata
      hrdata.each do |hrd|
        tp = HRMParser::TrackPoint.new
        
        if (interval == 238)
          rrcounter += hrd.to_i
          tp.hr = 60000 / hrd.to_i
          tp.time = start_time + (rrcounter/1000)
        else
          tp.hr = hrd.to_i
          tp.time = start_time + (interval * trackpoints.size)
        end
        
        trackpoints << tp
      end
      return trackpoints
    end
  end
end