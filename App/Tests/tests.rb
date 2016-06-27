require_relative '../../Framework/Application/config'
require_relative '../Application/sensors_mockups'
require_relative 'utils'

["classes"].each {
  |folderName|
  Dir.glob("#{File.dirname(__FILE__)}/../Application/#{folderName}/*.rb") { 
    |file|  
    require file
  }
}
require 'fiber'

# File to run App
#
# authors Sarkozi David
# version 2016

current = []
previous = []
activating = []
deactivating = []

root = Fiber.current

trace = TracePoint.new(:return) do |tp|
	#puts tp.inspect
	#puts tp.self
	#puts tp.defined_class
	unless Fiber.current == root
    trace.disable
    Fiber.yield false #unless tp.self.to_s == 'main'
  end
end

app = Main.new

fiber = Fiber.new do
  app.run
end

th = Thread.new do
  root = Fiber.current
  appName = "App"
  Application::Config.instance.setApp(app)
  current = Application::Config.instance.startup(appName)
  sleep 5
  o, current = Application::App::TemperatureSensor.factory({'degree' => 10})
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
		#p "D: " + deactivating.to_s
		deactivating.each do |feature|
			update_feature(feature.name, false)
		end
	end
	unless activating.empty? # prepend modules
		changed = true
		#p "A: " + activating.to_s
		activating.each do |feature|
			update_feature(feature.name, true)
		end
	end
	if fiber.alive?
		trace.enable
		returnval = fiber.resume (changed and returnval)
	else
		break
	end
end

th.join

# emergency, app = Application::AppERSMasterThesis::EmergencySensor.factory({'disaster'=>"earthquake"})
# puts app.run

# communication, app = Application::AppERSMasterThesis::CommunicationMeansSensor.factory({'type'=>"3G"})
# puts app.run

# battery, app = Application::AppERSMasterThesis::BatteryLevelSensor.factory({'level'=>19})
# puts app.run

# gps, app = Application::AppERSMasterThesis::LocationSensor.factory({'latitude'=>50, 'longitude'=>28})
# puts app.run
