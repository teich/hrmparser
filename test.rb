require 'spec/spec_helper'
require "lib/hrmparser"


workout = Workout.new(:file_name => "lib/samples/long-garmin.TCX")
workout.restore!
puts "#{workout.time} fun!"