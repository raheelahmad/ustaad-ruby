# require "version.rb"

module Ustaad
  class Ustaad
		MemoryStore = :memory_store
		FileStore = :file_store
		attr_reader :current_kitaab, :kitaabs, :store_type

		def initialize (*multi_args)
			if multi_args.length == 1 and multi_args.first.kind_of?(Hash)
				args = multi_args.first
				@nouns = args[:nouns]
				@verbs = args[:verbs]
				@store_type = args[:store_type]
			end

			@nouns ||= ['kitaabs', 'mushq']
			@verbs ||= ['list', 'use', 'ask']
			@store_type ||= FileStore
			@@kitaabs_dir ||= Dir.pwd + '/kitaabs'

			@kitaabs = []
			load_kitaabs if @store_type == FileStore
		end

		def load_kitaabs
			Dir.chdir(@@kitaabs_dir)
			Dir.glob('*.txt') { |txt|
				load_kitaab_from_file txt
			}
			if @kitaabs.length > 0 then @current_kitaab = @kitaabs.first end
		end

		def load_kitaab_from_file file
			file_path = @@kitaabs_dir + "/" + file
			kitaab = Kitaab.new({file_path:file_path})
			add_kitaab kitaab
		end
		
		def act args
			output = ''
			if !@verbs.include?(args[:verb])
				output = "Cannot do '#{args[:verb]}'"
			end
		  @verb = args[:verb]
		  @noun = args[:noun]

			if @verb == 'list'
				if @noun == 'kitaabs'
					kitaab_names.each { |k_name| puts "kitaab: #{k_name}" }
				else
					output = 'What should I list?'
				end
			elsif @verb == 'use'
				if @noun == nil
					output = "Please enter a kitaab name to use"
				elsif ! kitaab_names.include?(@noun)
					output = "I don't know kitaab: #{@noun}"
				end
				use_kitaab_with_name @noun
				output = "Now using #{@noun}"
			elsif @verb == 'ask'
				question = ask
				puts question
				answer = STDIN.gets
				if answer_for(question).strip.downcase == answer.strip.downcase
					output = 'YES'
				else
					output = 'NOPE'
				end
			else
				output = 'Cannot do anything'
			end

			output
		end
		
  	def add_kitaab_with_name(new_kitaab_name)
			@kitaabs << Kitaab.new(name:new_kitaab_name)
  	end
		
		def add_kitaab (new_kitaab)
			@kitaabs ||= []
			@kitaabs << new_kitaab
		end
		
		def kitaab_names
			@kitaabs.map { |e| e.name }
		end
		
		def use_kitaab_with_name(kitaab_name)
			@current_kitaab = @kitaabs.select { |kitaab| kitaab.name == kitaab_name }.first
		end
		
		def ask
			@current_kitaab.any_question
		end
		
		def ask_any
			@current_kitaab = @kitaabs[rand(@kitaabs.count)]
			ask
		end
		
		def answer_for (question)
			@current_kitaab.answer_for(question)
		end
  end
end
