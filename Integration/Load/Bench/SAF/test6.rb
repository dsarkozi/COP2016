require_relative "klass.rb"
#require_relative "module.rb"
#require_relative "main.rb"
require_relative "utils.rb"
require 'fiber'
require 'benchmark'

SWITCH = 500
CALL = 20000

k = Klass.new


Benchmark.bmbm do |x|

  x.report("No SAF") do
    CALL.times do
      k.foo
    end
  end
  
  x.report("No variants") do
    current = []
    previous = []
    activating = []
    deactivating = []

    trace = TracePoint.new(:return) do |tp|
	    #puts tp.inspect
	    #puts tp.self
	    #puts tp.defined_class
	    trace.disable
	    Fiber.yield false #unless tp.self.to_s == 'main'
    end
    fiber = Fiber.new do
      CALL.times do
      	k.foo
      end
      Fiber.yield 2
    end
    #th.abort_on_exception = true
    
    returnval = false
    trace.enable
    fiber.resume # first
    loop do
	    changed = false
	    trace.disable
	    activating, deactivating, previous = update_state(current, previous)
	    unless deactivating.empty? # remove modules
		    changed = true
		    #puts "D: " + deactivating.to_s
		    deactivating.each do |feature|
			    update_feature(feature, false)
		    end
	    end
	    unless activating.empty? # prepend modules
		    changed = true
		    #puts "A: " + activating.to_s
		    activating.each do |feature|
			    update_feature(feature, true)
		    end
	    end
	    if fiber.alive?
		    trace.enable
		    returnval = fiber.resume (changed and returnval)
	    else
		    break
	    end
    end
    #th.join
  end
  
  x.report("Variants") do
    current = ["#{SWITCH}"]
    previous = []
    activating = []
    deactivating = []

    trace = TracePoint.new(:return) do |tp|
	    #puts tp.inspect
	    #puts tp.self
	    #puts tp.defined_class
	    trace.disable
	    Fiber.yield false #unless tp.self.to_s == 'main'
    end
    fiber = Fiber.new do
      CALL.times do
      	k.foo
      end
      Fiber.yield 2
    end
    #th.abort_on_exception = true
    
    returnval = false
    trace.enable
    fiber.resume # first
    loop do
	    changed = false
	    trace.disable
	    activating, deactivating, previous = update_state(current, previous)
	    unless deactivating.empty? # remove modules
		    changed = true
		    #puts "D: " + deactivating.to_s
		    deactivating.each do |feature|
			    update_feature(feature, false)
		    end
	    end
	    unless activating.empty? # prepend modules
		    changed = true
		    #puts "A: " + activating.to_s
		    activating.each do |feature|
			    update_feature(feature, true)
		    end
	    end
	    if fiber.alive?
		    trace.enable
		    returnval = fiber.resume (changed and returnval)
	    else
		    break
	    end
    end
    #th.join
  end
end

