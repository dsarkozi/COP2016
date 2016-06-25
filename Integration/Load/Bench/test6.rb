require_relative "klass.rb"
#require_relative "module.rb"
#require_relative "main.rb"
require_relative "utils.rb"
require 'fiber'
require 'benchmark'

SWITCH = 50
CALL = 0

ifs = ""
SWITCH.times do |i|
  ifs += "if choice==#{i}
            return choice
          end
          "
end

Klass.class_eval "
  def if_method(choice)
    #{ifs}
    return 0
  end
  "

k = Klass.new


Benchmark.bmbm do |x|
  x.report("IF's:") do
    SWITCH.times do |i|
      choice = i % SWITCH
      CALL.times { k.if_method(choice) }
    end
  end
  x.report("Features") do
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
      SWITCH.times do
        CALL.times do
        	k.feature_method
	      end
	      Fiber.yield 2
      end
    end
    th = Fiber.new do
      SWITCH.times do |i|
	      current = ["#{i}"]
	      Fiber.yield
      end
    end
    #th.abort_on_exception = true
    
    returnval = false
    trace.enable
    fiber.resume # first
    loop do
      th.resume if returnval == 2
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

