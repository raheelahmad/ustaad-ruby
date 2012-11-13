# require "version.rb"

module Ustaad
  class Ustaad
		
		def initialize
			@nouns ||= ['notebooks', 'mushq']
			@verbs ||= ['list', 'use']
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
		
		def get_notebook_names
			@notebooks.map { |e| e.name }
		end
  end
end
