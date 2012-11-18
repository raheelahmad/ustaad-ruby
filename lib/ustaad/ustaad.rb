# require "version.rb"

module Ustaad
  class Ustaad
		MemoryStore = :memory_store
		FileStore = :file_store
		attr_reader :current_notebook, :notebooks, :store_type
		def initialize
			@nouns ||= ['notebooks', 'mushq']
			@verbs ||= ['list', 'use']
			@notebooks = []
			@store_type = FileStore
			@@kitaabs_dir ||= Dir.pwd + '/kitaabs'
			@@pair_separator = '||'
			# load_kitaabs
		end

		def load_kitaabs
			Dir.chdir(@@kitaabs_dir)
			Dir.glob('*.txt') { |txt|
				file_name = txt.split('.').first
				load_kitaab_from_file txt
			}
			puts notebook_names
		end

		def load_kitaab_from_file file_name
			kitaab = Kitaab.new(name:file_name)
			File.open(file_name).each do |line|
				pair = line.split(@@pair_separator)
				next if pair.count < 2
				kitaab.add_mushq_with_info ({:question => pair[0], :answer => pair[1]})
			end
			add_notebook kitaab
		end
		
		def act args
			if !@verbs.include?(args[:verb])
				puts "Cannot do #{args[:verb]}"
				exit
			elsif !@nouns.include?(args[:noun])
				puts "Don't know #{args[:noun]}"
				exit
			end
		  @verb = args[:verb]
		  @noun = args[:noun]
			puts "Will do #{@verb} on #{@noun}"
		end
		
  	def add_notebook_with_name(new_kitaab_name)
			@notebooks << Kitaab.new(name:new_kitaab_name)
  	end
		
		def add_notebook (new_kitaab)
			@notebooks ||= []
			@notebooks << new_kitaab
		end
		
		def notebook_names
			@notebooks.map { |e| e.name }
		end
		
		def use_notebook_with_name(kitaab_name)
			@current_notebook = @notebooks.select { |notebook| notebook.name == kitaab_name }.first
		end
		
		def ask
			@current_notebook.any_question
		end
		
		def ask_any
			@current_notebook = @notebooks[rand(@notebooks.count)]
			ask
		end
		
		def answer_for (question)
			@current_notebook.answer_for(question)
		end
  end
end
