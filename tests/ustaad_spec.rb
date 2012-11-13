require_relative '../lib/ustaad/ustaad'
require_relative '../lib/ustaad/mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad::Ustaad.new
	end
	
	it "should be creatable" do
		@ustaad.should_not == nil
  end
	
	# using kitaab
	
	it "should be able to hold on to an added notebook" do
	  @ustaad.add_notebook_with_name "Urdu"
		@ustaad.get_notebook_names.include?("Urdu").should == true
	end
	
	# persistence
	
	it "should persist mushqs between new Ustaad's" do
	  pending "Figure out persistence options (redis, couch-db)"
	end
	
end