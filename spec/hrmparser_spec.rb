require File.dirname(__FILE__) + '/spec_helper.rb'

# Time to add your specs!
# http://rspec.info/
module HRMParser
  describe "TrackPoint" do
    context "new trackpoint" do
      it "has no variables set" do
        hrm = TrackPoint.new
        hrm.speed == nil
        hrm.distance == nil
        hrm.lat.should == nil
        hrm.lng.should == nil
        hrm.altitude.should == nil
        hrm.hr.should == nil
      end
    end
  end

  describe "Workout" do
    context "new workout" do
      it "has no variables set" do
        workout = Workout.new
        workout.distance.should == nil
        workout.duration.should == nil
        workout.average_hr.should == nil
        workout.name.should == nil
        workout.file_name.should == nil
      end
      it "set name through initializer" do
        workout = Workout.new(:name => "test workout")
        workout.name.should == "test workout"
      end
      it "can not set average_hr during init" do
        workout = Workout.new(:average_hr => 150)
        workout.average_hr.should == nil
      end
    end

    context "Identifies files" do
      it "identify file as garmin" do
        type = Importer.file_type("spec/samples/small-garmin.TCX")
        type.should == "GARMIN_XML"
      end
      it "identification returns nil if no file specified" do
        type = Importer.file_type("")
        type.should == nil
      end
      it "identify file as polar" do
        type = Importer.file_type("spec/samples/polarRS400.hrm")
        type.should == "POLAR_HRM"
      end
    end

    context "Parse a GPS file" do
      it "finds the duration, time" do
        filename = "spec/samples/gps-with-suunto.gpx"
        data = File.read(filename)
        importer = Importer::GPX.new(:data => data)
        workout = importer.restore
        workout.time.should == Time.parse("Thu May 07 21:32:31 UTC 2009")

        # Duration is actualy less, but we don't account for stopped time right now
        workout.duration.should be_close(6382,1)
      end
      it "calculates the distance and speed" do
        filename = "spec/samples/gps-with-suunto.gpx"
        data = File.read(filename)
        importer = Importer::GPX.new(:data => data)
        workout = importer.restore
        workout.average_speed.should be_close(6.7, 0.2)
        workout.distance.should be_close(26427, 1)
      end
      it "handles files with drops" do
        filename = "spec/samples/gps-flat-run.gpx"
        data = File.read(filename)
        importer = Importer::GPX.new(:data => data)
        workout = importer.restore
        workout.average_speed.should be_close(2.9, 0.2)
        workout.distance.should be_close(11453, 1)
        workout.altitude_gain.should be_close(325, 10)
      end
    end

    context "Parse garmin file" do
      it "finds workout start time on a short workout" do
        filename = "spec/samples/indoor-garmin-405.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.time.should == Time.parse("Fri Aug 22 01:04:55 UTC 2008")
      end
      it "finds the duration on a short workout" do
        filename = "spec/samples/indoor-garmin-405.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.duration.should be_close(755, 1)
      end
      it "indoor workout has no trackpoints" do
        filename = "spec/samples/indoor-garmin-405.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.distance.should be_nil
        workout.average_hr.should be_nil
        workout.average_speed.should be_nil
        workout.altitude_gain.should be_nil
        workout.trackpoints.should == {}
      end

      # Parsing the full XML is just slow.  Commenting out for now.
      it "gets workout level settings for outdoor workout" do
        filename = "spec/samples/outdoor-garmin-405.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.distance.should be_close(11740, 5)
        workout.average_hr.should be_close(149.7, 0.5)
        workout.average_speed.should be_close(1.5, 0.2)
        workout.altitude_gain.should be_close(580, 25)
      end

      it "gets workout level settings for weird distance workout" do
        filename = "spec/samples/garmin-405-dies-distance.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.distance.should be_close(9426, 1)
        workout.average_hr.should == nil
        workout.average_speed.should be_close(6.7, 0.2)
        workout.altitude_gain.should be_close(40, 10)
      end

      it "doesn't have any 0 in latitude" do
        filename = "spec/samples/garmin-405-with-0-0.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.trackpoints.map {|tp| tp.lat.should_not == 0.0}
        workout.trackpoints.map {|tp| tp.lat.should_not == "undefined"}
      end
      
      it "handles files with INSANE duration" do
        filename = "spec/samples/insane-duration.TCX"
        data = File.read(filename)
        importer = Importer::Garmin.new(:data => data)
        workout = importer.restore
        workout.duration.should be_close(4996, 0.2)
      end
    end

    context "Parse polar RS400 file" do
      it "finds the duration and time" do
        filename ="spec/samples/polarRS400.hrm"
        data = File.read(filename)
        importer = Importer::Polar.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.duration.should be_close(3569,1)
        workout.time.should == Time.parse("Thu Apr 16 12:01:55 -0700 2009")
      end
      it "calculates the average heartrate" do
        filename ="spec/samples/polarRS400.hrm"          
        data = File.read(filename)
        importer = Importer::Polar.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.average_hr.should be_close(145, 1)
      end
    end

    context "Parse a Polar RR file" do
      it "calculates the heart rate from RR" do
        filename ="spec/samples/polarRS800-RR.hrm"         
        data = File.read(filename)
        importer = Importer::Polar.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.trackpoints.each {|tp| tp.hr.should < 220 && tp.hr.should > 30}
        workout.average_hr.should be_close(115, 1)
        workout.average_speed.should == nil
      end
    end

    context "Parse a Suunto T6C RR file" do
      it "finds the duration and time" do
        filename = "spec/samples/suunto-t6-RR-stops.sdf"
        data = File.read(filename)
        importer = Importer::Suunto.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.duration.should be_close(4781,1)
        workout.time.should == Time.parse("Thu May 07 14:16:07 -0700 2009")
      end
      it "calculates the average HR & altitude" do
        filename = "spec/samples/suunto-t6-RR-stops.sdf"
        data = File.read(filename)
        importer = Importer::Suunto.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.average_hr.should be_close(152,1)
        workout.average_speed.should == nil
        workout.trackpoints.each { |tp| tp.speed.should == nil }
        workout.altitude_gain.should be_close(115, 10)
      end
      it "calculates the speed and distance" do
        filename = "spec/samples/suunto-with-cadence-speed-distance.sdf"
        data = File.read(filename)
        importer = Importer::Suunto.new(:data => data, :time_zone => "Pacific Time (US & Canada)")
        workout = importer.restore
        workout.average_hr.should be_close(131,1)
        workout.average_speed.should be_close(9.3, 0.1)
        workout.altitude_gain.should be_close(75, 15)
        workout.distance.should == 124597
      end


    end
  end
end
