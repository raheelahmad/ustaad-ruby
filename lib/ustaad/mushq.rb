module Ustaad
	class Mushq
		attr_accessor :question, :answer
		def initialize(q_and_a)
			@question = q_and_a[:question]
			@answer = q_and_a[:answer]
		end
	end
end
