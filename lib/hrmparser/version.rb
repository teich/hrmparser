module HRMParser # :nodoc:
  module VERSION # :nodoc:
    unless defined? MAJOR
      MAJOR  = 0
      MINOR  = 1
      TINY   = 3
      
      STRING = [MAJOR, MINOR, TINY].compact.join('.')

      SUMMARY = "HRMParser #{STRING}"
    end
  end
end
