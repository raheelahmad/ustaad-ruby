require_relative '../lib/ustaad/mushq'

describe Ustaad::Mushq do
	before(:each) do
		@q = 'What is the capital of India?'
		@a = 'Delhi'
	  @mushq = Ustaad::Mushq.new( question:@q, answer:@a )
	end
	
  it "should be initialized with a question and an answer" do
  	@mushq.should_not == nil
  end
	
	it "should give the original question and answer back" do
	  @mushq.question.should == @q
	  @mushq.answer.should == @a
	end
end