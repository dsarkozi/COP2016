require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	f = Foo.new
	loop do
		#sleep 1
		puts f.yell
	end
end

th = Thread.new do
	sleep 3
	Foo.class_eval "prepend M;"
end

fiber.resume
puts "Hello"
#th.join
