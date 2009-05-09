require 'importer/garmin'
require 'importer/polar'
require 'importer/suunto'
require 'importer/gpx'

module Importer
	def Importer.file_type(name)
		case name
		when /\.tcx$/i
			return "GARMIN_XML" 
		when /\.hrm$/i
			return "POLAR_HRM"
		when /\.sdf$/i
			return "SUUNTO"
		when /\.gpx$/i
			return "GPX"
		end
	end

	def Importer.read_in_file(name)
		if File.readable?(name)
			return open(name, "r")
		else 
			puts "FILE ERROR, can't read #{name}"
		end
	end
end

