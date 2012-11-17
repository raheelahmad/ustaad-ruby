# require "version.rb"

module Ustaad
  class Ustaad
		MemoryStore = :memory_store
		FileStore = :file_store
		attr_reader :current_notebook, :store_type
		def initialize
			@nouns ||= ['notebooks', 'mushq']
			@verbs ||= ['list', 'use']
			@store_type = FileStore
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
  		@notebooks ||= []
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
