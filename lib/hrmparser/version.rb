module HRMParser # :nodoc:
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 0
      TINY   = 1
      
      STRING = [MAJOR, MINOR, TINY].compact.join('.')

      SUMMARY = "HRMParser #{STRING}"
    end
  end
end
