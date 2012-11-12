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
	
	# persistence
	
	it "should persist mushqs between new Ustaad's" do
	  pending "Figure out persistence options (redis, couch-db)"
	end
	
end