require_relative '../Utils/utils_tests'
require_relative '../../TestExecution/Application/sensors_mockups'

# File to test the framework
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

now = Time.now
start = now
end_time = now + 5 # now + 5 seconds

degree = Utils::UtilsTests.generate_degree
Application::TemperatureSensor.factory({'degree'=>degree})

lat, long = Utils::UtilsTests.generate_gps_data
Application::GpsSensor.factory({'latitude'=>lat, 'longitude'=>long})

while now < end_time
  begin
    degree = Utils::UtilsTests.generate_degree
    Application::TemperatureSensor.factory({'degree'=>degree})

    lat, long = Utils::UtilsTests.generate_gps_data
    Application::GpsSensor.factory({'latitude'=>lat, 'longitude'=>long})
  rescue Exception => e
  end
  now = Time.now
end

puts "start = #{start}"
puts "end_time = #{end_time}"