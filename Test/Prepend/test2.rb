require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

fiber = Fiber.new do
	loop do
		#sleep 1
		f = Foo.new
		puts f.yell if defined? f.yell
		f.bidule if defined? f.bidule
	end
end

th = Thread.new do
	sleep 3
	Foo.class_eval "prepend M;"
end

fiber.resume
puts "Hello"
#th.join
