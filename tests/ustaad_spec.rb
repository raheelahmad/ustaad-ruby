require_relative '../lib/ustaad/ustaad'
require_relative '../lib/ustaad/mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad::Ustaad.new
	end
	
	# Helpers
	
	def add_default_notebooks_to_ustaad an_ustaad
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
			an_ustaad.add_notebook kitaab
	  end
		
		@all_questions = [].concat(q1s).concat(q2s)
		@all_answers = [].concat(a1s).concat(a2s)
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
	  add_default_notebooks_to_ustaad (@ustaad)
		
		@ustaad.use_notebook_with_name @notebook_info[0][:name]
		q = @ustaad.ask
		@notebook_info[0][:questions].include?(q).should == true
		@notebook_info[0][:answers].include?(@ustaad.answer_for(q)).should == true
	end
	
	it "should be able to ask a question from any notebook" do
	  add_default_notebooks_to_ustaad (@ustaad)
		
		@all_questions.include?(@ustaad.ask_any).should == true
	end
	
	# persistence
	
	it "should persist notebook names between new Ustaad's" do
		ustaad_one = Ustaad::Ustaad.new; ustaad_one.load_kitaabs
		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		ustaad_one.notebook_names.each do |a_notebook_name|
			ustaad_two.notebook_names.include?(a_notebook_name).should == true
		end
	end

	it "should persist notebook mushqs between new Ustaad's" do
		ustaad_one = Ustaad::Ustaad.new; ustaad_one.load_kitaabs
		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		ustaad_one.notebooks.each do |a_notebook|
			b_notebook = ustaad_two.notebooks.select { |b_n| b_n.name == a_notebook.name }.first
			b_notebook.should_not == nil
			a_notebook.mushqs.each do |a_mushq|
				found_matching_mushq = false
				b_notebook.mushqs.each do |b_mushq|
					if b_mushq.question == a_mushq.question && b_mushq.answer == a_mushq.answer
						found_matching_mushq = true 
					end
				end
				found_matching_mushq.should == true
			end
		end
	end
	
	it "should persist added mushqs between new Ustaad's" do
		ustaad_one = Ustaad::Ustaad.new; ustaad_one.load_kitaabs
		a_notebook = ustaad_one.notebooks.first
		a_notebook.should_not == nil
		question = 'Where is Qutub Minar?'; answer = 'New Delhi'
		a_notebook.add_mushq_with_info ({question:question, answer:answer})

		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		questions_in_two = []
		ustaad_two.notebooks.each do |n_two|
			questions_in_two.concat (n_two.all_questions)
		end
		questions_in_two.include?(question).should == true
	end
end
