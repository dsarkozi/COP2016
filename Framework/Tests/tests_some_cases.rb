require_relative '../Application/config'
require_relative '../Application/time_filter'
require_relative '../../AppTestExecution/Application/sensors_mockups'

# File to test the framework in certains cases
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

app = Application::Config.startup("AppTestExecution")
puts app.run

temp, app = Application::AppTestExecution::TemperatureSensor.factory({'degree'=>-510})  # Hot
puts app.run
# temp, app = Application::AppTestExecution::TemperatureSensor.factory({'degree'=>-25}) # Very Frost
# puts app.run
# temp, app = Application::AppTestExecution::TemperatureSensor.factory({'degree'=>5})   # Cold
# puts temp, app.run