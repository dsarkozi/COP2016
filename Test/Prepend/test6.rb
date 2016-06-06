require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	f = Foo.new
	loop do
		sleep 1
		f.bar
		#puts
		#puts Foo.ancestors
	end
end

th = Thread.new do
	sleep 3
	Foo.class_eval "prepend D;"
	sleep 3
	#undo
	Foo.send(:remove_const, D)
end
th.abort_on_exception = true

fiber.resume
puts "Hello"
#th.join
