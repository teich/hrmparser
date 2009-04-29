module ArrayMath

  def average
    return 0.0 if self.size == 0
    self.sum / self.size
  end

  def sum
    inject(0){ |sum,item| sum + item }
  end
end

class Array
  include ArrayMath
end
