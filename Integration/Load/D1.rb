module Foo1
	attr_accessor :lol
	
	def initialize
		@lol = "lol"
		super
	end

	def bar
		puts "I'm D1 bar !"
	end
	
	def setlol
	  @lol = "lol"
	end
	
	def loo
		puts "loo"
	end
end

module Foo1S
	attr_accessor :hell	
	
	def initialize
		@hell = "hell"
	end
	
	def test
		puts "Test"
	end
end
