class Foo
	attr_accessor :yell
	
	def initialize
		@yell = "yell"
	end
	
	def bar
		#slow
		puts "I'm bar !"
	end
	
	def self.bar
		puts "single bar"
	end
	
	def foo(bar)
		puts bar
	end
	
	def slow
		sleep 5
	end
end
