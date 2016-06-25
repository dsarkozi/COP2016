class Foo
	attr_reader :foobar
	
	def initialize
		@foobar = 42
	end
	
	def bar
		puts "I'm bar !"
	end
	
	def foo
		puts "I am foo"
	end
end
