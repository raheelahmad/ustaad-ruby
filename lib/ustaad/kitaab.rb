module Ustaad
	class Kitaab
		attr_reader :name, :mushqs
		attr_accessor :file_path
	
		def initialize (info)
			@@pair_separator = '||'
			@mushqs = []
			if info[:name] != nil
				@name = info[:name]
			elsif info[:file_path] != nil
				@file_path = info[:file_path]
				@name = file_path.split('/').last.split('.').first
				load_mushqs_from_file
			end
		end

		def load_mushqs_from_file
			@loading = true
			File.open(@file_path).each do |line|
				pair = line.split(@@pair_separator)
				next if pair.count < 2
				add_mushq_with_info ({:question => pair[0].strip, :answer => pair[1].strip})
			end		
			@loading = false
		end

		def add_mushq (mushq)
			previous_mushqs = @mushqs.select {|m| m.question == mushq.question}
			if previous_mushqs.count > 0
				previous_mushq = previous_mushqs.first
				previous_mushq.answer = mushq.answer
			else
				@mushqs << mushq
				save_mushq_to_file (mushq) if @file_path != nil && !@loading
			end
		end

		def save_mushq_to_file (mushq)
			file = File.open(@file_path)
			open(@file_path, 'a') { |f|
				f.puts "#{mushq.question} #{@@pair_separator} #{mushq.answer}"
			}
		end

		def add_mushq_with_info (mushq_info)
			add_mushq Mushq.new(mushq_info)
		end
	
		def mushqs
			return @mushqs
		end
	
		def all_questions
			qs = []
			@mushqs.each {|m| qs << m.question}
			qs
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
end
