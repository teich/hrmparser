require 'rubygems' 
require 'hpricot'
require 'time'

module HRMParser; end

$LOAD_PATH.unshift(File.dirname(__FILE__) + '/hrmparser')

require 'arraymath'
require 'trackpoint'
require 'workout'
require 'importer'
