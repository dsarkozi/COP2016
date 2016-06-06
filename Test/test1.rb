require_relative "klass.rb"
#require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	main
end

th = Thread.new do
	sleep 3
	feature = IO.read "M.rb"
	Foo.class_eval feature
	sleep 3
	feature = IO.read "D.rb"
	Foo.class_eval feature
end

fiber.resume
puts "Hello"
#th.join
