require 'enumerator'

# Set of basic array math functions.  
module ArrayMath

	def aaverage
		accum = self.asum
		return nil if accum.nil? || self.size == 0
		accum.to_f / self.size
	end

	def asum
		self.map {|i| return nil if i.is_a?(String)}
		inject(0){ |sum,item| sum + item }
	end

	## Retun array FACTOR smaller.  Average values to get smaller
	def smoothed(factor)
		self.enum_for(:each_slice, factor).map { |snipit| snipit.compact.aaverage }
	end  
end

class Array
	include ArrayMath
end
