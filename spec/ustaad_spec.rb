require_relative '../ustaad'
require_relative '../mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad.new
		@qs = ['What is the cpaital of India', 'When did India get independence?', 'What is the freezing point of water?']
		@as = ['Delhi', 1947, '100 F']
	end
	
  it "should be creatable" do
		@ustaad.should_not == nil
  end
	
	it "should be able to take a new Mushq" do
		mushq = Mushq.new(:question => @qs.first, :answer => @as.first)
		@ustaad.add_mushq(mushq)
		@ustaad.all_mushqs.include?(mushq).should == true
	end
	
	it "should give a question from an added mushq" do
	  @qs.each_index	{ |idx|
			q = @qs[idx]
			a = @as[idx]
			m = Mushq.new(question:q, answer:a)
			@ustaad.add_mushq(m)
		}
		puts @ustaad.any_question
		@qs.include?(@ustaad.any_question).should == true
	end
end