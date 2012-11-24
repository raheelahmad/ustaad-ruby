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
			@verbs ||= ['list', 'use']
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
		end

		def load_kitaab_from_file file
			file_path = @@kitaabs_dir + "/" + file
			kitaab = Kitaab.new({file_path:file_path})
			add_kitaab kitaab
		end
		
		def act args
			if !@verbs.include?(args[:verb])
				puts "Cannot do '#{args[:verb]}'"
				exit
			end
		  @verb = args[:verb]
		  @noun = args[:noun]

			if @verb == 'list' and @noun == 'kitaabs'
				kitaab_names.each { |k_name| puts "kitaab: #{k_name}" }
			elsif @verb == 'use'
				if @noun == nil
					puts "Please enter a kitaab name to use"
					exit
				elsif ! kitaab_names.include?(@noun)
					puts "I don't know kitaab: #{@noun}"
					exit
				end
				use_kitaab_with_name @noun
			end
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
