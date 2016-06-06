require "./klass.rb"

def main
	loop do
		sleep 1
		f = Foo.new
		f.bar
		f.foo(42)
		#puts Foo.ancestors
		#Fiber.yield
	end
end
