require_relative '../ustaad'
require_relative '../mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad.new
		@qs = ['What is the cpaital of India', 'When did India get independence?', 'What is the freezing point of water?']
		@as = ['Delhi', 1947, '100 F']
	end
	
	# using mushqs
	
	def add_mushqs
	  @qs.each_index	{ |idx|
			@ustaad.add_mushq Mushq.new(question:@qs[idx], answer:@as[idx])
		}
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
	  add_mushqs
		@qs.include?(@ustaad.any_question).should == true
	end
	
	it "should confirm the correct answer to a question" do
		add_mushqs
	  q = @ustaad.any_question
		our_a = @as[@qs.index(q)]
		@ustaad.answer_for(q).should == our_a
	end
	
	
	# persistence
	
	it "should persist mushqs between new Ustaad's" do
	  pending "Figure out persistence options (redis, couch-db)"
	end
	
end