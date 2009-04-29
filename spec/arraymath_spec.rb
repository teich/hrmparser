require File.dirname(__FILE__) + '/spec_helper.rb'

module ArrayMath
  describe "ArrayMath" do
    context "Sum" do
      it "sums an array" do
        array = [1,2,3,4,5]
        array.sum.should == 15
      end
      it "can not sum an array of strings" do
        array = ["hello", "goodbye"]
        array.sum.should == nil
      end
    end
    context "average" do
      it "averages an array of integers and returns a float" do
        array = [2,3,4,3,2]
        array.average.should == 2.8
      end
      it "averages an array of floats" do
        array = [1.5,2.5,3.5,2.5,1.5]
        array.average.should == 2.3
      end
    end
  end
end