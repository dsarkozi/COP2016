require "./klass.rb"

def main
	f = Foo.new
	loop do
		sleep 1
		f.bar
		f.foo(42)
		#puts Foo.ancestors
		#Fiber.yield
	end
end
