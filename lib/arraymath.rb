require 'enumerator'

# Set of basic array math functions.  
module ArrayMath

  def average
    return 0.0 if self.size == 0
    self.sum / self.size
  end

  def sum
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
