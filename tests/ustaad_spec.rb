require_relative '../lib/ustaad/ustaad'
require_relative '../lib/ustaad/mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad::Ustaad.new
	end
	
	# Helpers
	
	def add_default_notebooks
		@notebook_info = []
		q1s = ['What is the cpaital of India', 'When did India get independence?', 'What is the freezing point of water?']
		a1s = ['Delhi', 1947, '100 F']
		@notebook_info << {name:'GK', questions:q1s, answers:a1s}
		
		q2s = ['musafir', 'faqat', 'ghaafil']
		a2s = ['traveler', 'only', 'unbenkownst']
		@notebook_info << {name:'Urdu', questions:q2s, answers:a2s}
		
	  @notebook_info.each do |an_info|
	  	kitaab = Ustaad::Kitaab.new({name:an_info[:name]})
			questions = an_info[:questions]
			questions.each_index do |idx|
				ques = an_info[:questions][idx]
				ans = an_info[:answers][idx]
				m = Ustaad::Mushq.new ({:question => ques, :answer => ans})
				kitaab.add_mushq(m)
			end
			@ustaad.add_notebook kitaab
	  end
		
		@all_questions = [].concat(q1s).concat(q2s)
	end
	
	# ----
	
	it "should be creatable" do
		@ustaad.should_not == nil
  end
	
	# using kitaab
	
	it "should be able to hold on to an added notebook" do
	  @ustaad.add_notebook_with_name "Urdu"
		@ustaad.notebook_names.include?("Urdu").should == true
	end
	
	it "should be able to list all added notebooks" do
	  notebook_names = ['Urdu', 'English', 'Swahili']
		notebook_names.each do |name|
			@ustaad.add_notebook_with_name name
		end
		
		ustad_notebook_names = @ustaad.notebook_names
		notebook_names.each do |name|
			ustad_notebook_names.include?(name).should == true
		end
	end
	
	it "should be able to set current notebook" do
		notebook_names = ['Urdu', 'English', 'Swahili']
		notebook_names.each do |name|
			@ustaad.add_notebook_with_name name
		end
		
		@ustaad.use_notebook_with_name 'Urdu'
		@ustaad.current_notebook.name == 'Urdu'
	end
	
	it "should be able to ask a question from current notebook" do
	  add_default_notebooks
		
		@ustaad.use_notebook_with_name @notebook_info[0][:name]
		@notebook_info[0][:questions].include?( @ustaad.ask ).should == true
	end
	
	it "should be able to ask a question from any notebook" do
	  add_default_notebooks
		
		@all_questions.include?(@ustaad.ask_any).should == true
	end
	
	# persistence
	
	it "should persist mushqs between new Ustaad's" do
	  pending "Figure out persistence options (redis, couch-db)"
	end
	
end