require 'enumerator'

# Set of basic array math functions.  
module ArrayMath

  def average
    accum = self.sum
    return nil if accum.nil? || self.size == 0
    accum / self.size
  end

  def sum
    self.map {|i| return nil if i.is_a?(String)}
    inject(0){ |sum,item| sum + item }
  end
  
  ## Retun array FACTOR smaller.  Average values to get smaller
  def smoothed(factor)
    self.enum_for(:each_slice, factor).map { |snipit| snipit.compact.average }
  end  
end

class Array
  include ArrayMath
end
