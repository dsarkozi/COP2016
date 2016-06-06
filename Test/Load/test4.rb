require_relative "klass.rb"
#require_relative "module.rb"
#require_relative "main.rb"
require_relative "utils.rb"
require 'fiber'

current = []
previous = []
activating = []
deactivating = []

trace = TracePoint.new(:return) do |tp|
	puts tp.inspect
	#puts tp.self
	#puts tp.defined_class
	trace.disable
	Fiber.yield false #unless tp.self.to_s == 'main'
end

fiber = Fiber.new do
	f = Foo.new
	10.times do
		sleep 1
		f.bar
		f.loo if defined? f.loo
		Foo.test if defined? Foo.test
		#puts Foo.ancestors
	end
end

th = Thread.new do
	sleep 3
	current = ['D1']
	sleep 3
	current = ['D2']
	#remove_feature(D, Ds)
	#prepend_feature(Foo, 'D', nil, 'D2.rb')
	sleep 3
	current = []
	#remove_feature(D, nil)
end
th.abort_on_exception = true

returnval = false
trace.enable
fiber.resume # first
loop do
	changed = false
	trace.disable
	activating, deactivating, previous = update_state(current, previous)
	unless deactivating.empty? # remove modules
		changed = true
		puts "D: " + deactivating.to_s
		deactivating.each do |feature|
			remove_feature(Foo1, Foo1S)
		end
	end
	unless activating.empty? # prepend modules
		changed = true
		puts "A: " + activating.to_s
		activating.each do |feature|
			prepend_feature(Foo, 'Foo1', 'Foo1S', feature + '.rb')
		end
	end
	if fiber.alive?
		trace.enable
		puts 'alive'
		puts changed
		puts returnval
		returnval = fiber.resume (changed and returnval)
	else
		break
	end
end

puts "Hello"
th.join
