require_relative "klass.rb"
#require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	f = Foo.new
	loop do
		sleep 1
		f.bar
		f.foo(42)
	end
end

th = Thread.new do
	sleep 3
	load('D1.rb')
	Foo.class_eval "prepend D;"
	sleep 3
	load('D2.rb')
	sleep 3
	load('Empty.rb')
end

fiber.resume
puts "Hello"
#th.join
