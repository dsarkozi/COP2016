require_relative "klass.rb"
require_relative "module4.rb"
require_relative "main.rb"

fiber = Fiber.new do
	f = Foo.new
	loop do
		sleep 1
		Foo.bar
		puts Foo.singleton_class.ancestors
	end
end

th = Thread.new do
	sleep 3
	Foo.class_eval "prepend M;"
end

fiber.resume
puts "Hello"
#th.join
