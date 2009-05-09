require 'importer/garmin'
require 'importer/polar'
require 'importer/suunto'

module Importer
	def Importer.file_type(name)
		case name
		when /\.tcx$/i
			return "GARMIN_XML" 
		when /\.hrm$/i
			return "POLAR_HRM"
		when /\.sdf$/i
			return "SUUNTO"
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

