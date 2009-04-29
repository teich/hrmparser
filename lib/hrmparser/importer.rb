require 'importer/garmin'
require 'importer/polar'

module Importer
  def Importer.file_type(name)
    if name =~ /\.tcx$/i
      "GARMIN_XML" 
    elsif name =~ /\.hrm$/i
      "POLAR_HRM"
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