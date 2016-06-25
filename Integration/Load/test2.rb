require_relative "klass.rb"
#require_relative "module.rb"
require_relative "main.rb"

def remove_module(mod)
	mod.instance_methods(false).each do |meth|
		mod.send(:remove_method, meth)
	end
end

fiber = Fiber.new do
	f = Foo.new
	10.times do
		sleep 1
		f.bar
		f.loo if defined? f.loo
		Foo.test if defined? Foo.test
		puts f.lol if defined? f.lol
		puts Foo.hell if defined? Foo.hell
		#puts Foo.ancestors
	end
end

th = Thread.new do
	sleep 3
	load('D1.rb')
	Foo.class_eval "prepend D;"
	Foo.singleton_class.class_eval "prepend Ds;"
	Foo.send(:initialize)
	#Foo = Class.new(Foo)
	sleep 3
	remove_module(D)
	remove_module(Ds)
	load('D2.rb')
	Foo.class_eval "prepend D;"
	sleep 3
	remove_module(D)
end
th.abort_on_exception = true

fiber.resume
puts "Hello"
th.join
