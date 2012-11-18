require_relative '../lib/ustaad/kitaab'
require_relative '../lib/ustaad/mushq'

describe Ustaad::Kitaab do
  before(:each) do
		@kitaab = Ustaad::Kitaab.new(name:'Urdu')
		@qs = ['What is the cpaital of India', 'When did India get independence?', 'What is the freezing point of water?']
		@as = ['Delhi', 1947, '100 F']
  end
	
	# using mushqs
	
	def add_mushqs
	  @qs.each_index	{ |idx|
			@kitaab.add_mushq (Ustaad::Mushq.new({question:@qs[idx], answer:@as[idx]}))
		}
	end
	
	it "should be able to take a new Mushq" do
		mushq = Ustaad::Mushq.new({:question => @qs.first, :answer => @as.first})
		@kitaab.add_mushq(mushq)
		@kitaab.mushqs.include?(mushq).should == true
	end
	
	it "should give a question from an added mushq" do
	  add_mushqs
		@qs.include?(@kitaab.any_question).should == true
	end

	it "should give all added mushqs' questions" do
		add_mushqs
		k_qs = @kitaab.all_questions
		@qs.each { |q| k_qs.include?(q).should == true }
	end
	
	it "should confirm the correct answer to a question" do
		add_mushqs
	  q = @kitaab.any_question
		our_a = @as[@qs.index(q)]
		@kitaab.answer_for(q).should == our_a
	end
end
