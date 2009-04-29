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
          type = Importer.file_type("spec/samples/polarRS200.hrm")
          type.should == "POLAR_HRM"
        end
      end

      context "Parse garmin file" do
        it "finds workout start time" do
          filename = "spec/samples/indoor-garmin-405.TCX"
          importer = Importer::Garmin.new(:file_name => filename)
          workout = importer.restore
          workout.time.should == "2008-08-22T01:04:55Z"
        end
        it "finds the duration" do
          filename = "spec/samples/indoor-garmin-405.TCX"
          importer = Importer::Garmin.new(:file_name => filename)
          workout = importer.restore
          workout.duration.should be_close(755, 1)
        end
        it "indoor workout has no trackpoints" do
          filename = "spec/samples/indoor-garmin-405.TCX"
          importer = Importer::Garmin.new(:file_name => filename)
          workout = importer.restore
          workout.distance.should == nil
          workout.average_hr.should == nil
          workout.average_speed.should == nil
          workout.altitude_gain.should == nil
          workout.trackpoints == nil
        end
        it "gets workout level settings for outdoor workout" do
          filename = "spec/samples/outdoor-garmin-405.TCX"
          importer = Importer::Garmin.new(:file_name => filename)
          workout = importer.restore
          workout.distance.should be_close(11740, 5)
          workout.average_hr.should be_close(149.7, 0.5)
          workout.average_speed.should be_close(1.5, 0.2)
          workout.altitude_gain.should be_close(572, 1.0)
        end
      end
    end


end
