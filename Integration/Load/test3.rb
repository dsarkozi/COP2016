require_relative "klass.rb"
#require_relative "module.rb"
require_relative "main.rb"
require_relative "utils.rb"

fiber = Fiber.new do
	f = Foo.new
	10.times do
		sleep 1
		f.bar
		f.loo if defined? f.loo
		Foo.test if defined? Foo.test
		#puts Foo.included_modules
	end
end

th = Thread.new do
	sleep 3
	prepend_feature(Foo, 'D', 'Ds', 'D1.rb')
	sleep 3
	remove_feature(D, Ds)
	prepend_feature(Foo, 'D', nil, 'D2.rb')
	sleep 3
	remove_feature(D, nil)
end
th.abort_on_exception = true

fiber.resume
puts "Hello"
th.join
