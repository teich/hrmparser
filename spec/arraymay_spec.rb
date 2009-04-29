require File.dirname(__FILE__) + '/spec_helper.rb'

module ArrayMath
  describe "ArrayMath" do
    context "Sum" do
      it "sums an array" do
        array = [1,2,3,4,5]
        array.sum.should == 15
      end
    end
  end
end