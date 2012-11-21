require_relative '../lib/ustaad/ustaad'
require_relative '../lib/ustaad/mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad::Ustaad.new
	end
	
	# Helpers
	
	def add_default_kitaabs_to_ustaad an_ustaad
		@kitaab_info = []
		q1s = ['What is the cpaital of India', 'When did India get independence?', 'What is the freezing point of water?']
		a1s = ['Delhi', 1947, '100 F']
		@kitaab_info << {name:'GK', questions:q1s, answers:a1s}
		
		q2s = ['musafir', 'faqat', 'ghaafil']
		a2s = ['traveler', 'only', 'unbenkownst']
		@kitaab_info << {name:'Urdu', questions:q2s, answers:a2s}
		
	  @kitaab_info.each do |an_info|
	  	kitaab = Ustaad::Kitaab.new({name:an_info[:name]})
			questions = an_info[:questions]
			questions.each_index do |idx|
				ques = an_info[:questions][idx]
				ans = an_info[:answers][idx]
				m = Ustaad::Mushq.new ({:question => ques, :answer => ans})
				kitaab.add_mushq(m)
			end
			an_ustaad.add_kitaab kitaab
	  end
		
		@all_questions = [].concat(q1s).concat(q2s)
		@all_answers = [].concat(a1s).concat(a2s)
	end
	
	# ----
	
	it "should be creatable" do
		@ustaad.should_not == nil
  end
	
	# using kitaab
	
	it "should be able to hold on to an added kitaab" do
	  @ustaad.add_kitaab_with_name "Urdu"
		@ustaad.kitaab_names.include?("Urdu").should == true
	end
	
	it "should be able to list all added kitaabs" do
	  kitaab_names = ['Urdu', 'English', 'Swahili']
		kitaab_names.each do |name|
			@ustaad.add_kitaab_with_name name
		end
		
		ustad_kitaab_names = @ustaad.kitaab_names
		kitaab_names.each do |name|
			ustad_kitaab_names.include?(name).should == true
		end
	end
	
	it "should be able to set current kitaab" do
		kitaab_names = ['Urdu', 'English', 'Swahili']
		kitaab_names.each do |name|
			@ustaad.add_kitaab_with_name name
		end
		
		@ustaad.use_kitaab_with_name 'Urdu'
		@ustaad.current_kitaab.name == 'Urdu'
	end
	
	it "should be able to ask a question from current kitaab" do
	  add_default_kitaabs_to_ustaad (@ustaad)
		
		@ustaad.use_kitaab_with_name @kitaab_info[0][:name]
		q = @ustaad.ask
		@kitaab_info[0][:questions].include?(q).should == true
		@kitaab_info[0][:answers].include?(@ustaad.answer_for(q)).should == true
	end
	
	it "should be able to ask a question from any kitaab" do
	  add_default_kitaabs_to_ustaad (@ustaad)
		
		@all_questions.include?(@ustaad.ask_any).should == true
	end
	
	# persistence
	
	it "should persist kitaab names between new Ustaad's" do
		ustaad_one = Ustaad::Ustaad.new; ustaad_one.load_kitaabs
		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		ustaad_one.kitaab_names.each do |a_kitaab_name|
			ustaad_two.kitaab_names.include?(a_kitaab_name).should == true
		end
	end

	it "should persist kitaab mushqs between new Ustaad's" do
		ustaad_one = Ustaad::Ustaad.new; ustaad_one.load_kitaabs
		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		ustaad_one.kitaabs.each do |a_kitaab|
			b_kitaab = ustaad_two.kitaabs.select { |b_n| b_n.name == a_kitaab.name }.first
			b_kitaab.should_not == nil
			a_kitaab.mushqs.each do |a_mushq|
				found_matching_mushq = false
				b_kitaab.mushqs.each do |b_mushq|
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
		a_kitaab = ustaad_one.kitaabs.first
		a_kitaab.should_not == nil
		question = 'Where is Qutub Minar?'; answer = 'New Delhi'
		a_kitaab.add_mushq_with_info ({question:question, answer:answer})

		ustaad_two = Ustaad::Ustaad.new; ustaad_two.load_kitaabs
		questions_in_two = []
		ustaad_two.kitaabs.each do |n_two|
			questions_in_two.concat (n_two.all_questions)
		end
		questions_in_two.include?(question).should == true
	end
end
