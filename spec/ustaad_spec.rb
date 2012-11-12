require_relative '../ustaad'
require_relative '../mushq'

describe Ustaad do
	before(:each) do
    @ustaad = Ustaad.new
	end
	
	it "should be creatable" do
		@ustaad.should_not == nil
  end
	
	
	# using kitaab
	
	it "should be able to add a new kitaab" do
	  @ustaad.add_kitaab(name:'Urdu')
	end
	
	
	# persistence
	
	it "should persist mushqs between new Ustaad's" do
	  pending "Figure out persistence options (redis, couch-db)"
	end
	
end