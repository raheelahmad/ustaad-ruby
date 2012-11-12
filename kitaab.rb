class Kitaab
	attr_reader :name, :mushqs
	
	def initialize (info)
		@name = info[:name]
		@mushqs = []
	end
	
	def add_mushq (mushq)
		@mushqs << mushq
	end
	
	def all_mushqs
		return @mushqs
	end
	
	def any_question
		random_index = rand(@mushqs.count)
		return @mushqs.at(random_index).question
	end

	def answer_for (question)
		matches = @mushqs.select { |m| m.question == question }
		matches.first.answer
	end
end