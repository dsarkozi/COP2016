require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	main
end

th = Thread.new do
	sleep 3
	Foo.class_eval "prepend M;"
	sleep 3
	Foo.class_eval "prepend D;"
end

fiber.resume
puts "Hello"
#th.join
