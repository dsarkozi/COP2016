module Foo2
  CONST = 0
  
	def bar
		returnval = Fiber.yield true
		return if returnval
		puts "I'm D2 bar !"
		#cop_return
	end
	
	def const
	  puts CONST
	end
end

module Foo1
	def nested
		puts 'nested'
	end
end
