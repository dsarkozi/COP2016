require_relative '../../TestExecution/Application/sensors_mockups'

# File to test dependencies from beginning process
#
# authors Duhoux Benoît
# version 2015

module Handling
  class ContextActivation
    include Singleton, Logging
    def activate(o, contexts)
      logger.debug { "Can activate contexts ? #{contexts.map { |context| context.name }} ? ..." }
      activedContextsCounters = Application::ContextDefinition.instance.activedContextsCounters
      logger.debug { "Old activate contexts : #{activedContextsCounters}" }
      activedContexts = activedContextsCounters.clone
      managedContexts = {}
      begin
        contexts.each { 
          |context|
          context.canActivate(activedContexts, managedContexts)  
        }
        Application::ContextDefinition.instance.setActivedContextCounters(activedContexts)
      rescue Exceptions::DependencyException => e
        logger.debug { "Impossible to (de)activate contexts : #{e}" }
      end
      activedContextsCounters = Application::ContextDefinition.instance.activedContextsCounters
      logger.debug { "New activate contexts : #{activedContextsCounters}" }
      # FeatureSelection.instance.select(o, managedContexts)
    end
  end
end

module Application
  class TemperatureFilter < TimeFilter
    def initialize
      super
      @new_wait_to_filter = 0
    end
  end
  class GpsFilter < TimeFilter
    def initialize
      super
      @new_wait_to_filter = 0
    end
  end
end

##########################################
# Test XOR (OK)
##########################################
# Config:
# "Temperature": {
#     "xor": []
# }
##########################################
# temp, app = Application::TemperatureSensor.factory({'degree'=>35})                            # Hot
# temp, app = Application::TemperatureSensor.factory({'degree'=>10})                            # Cold
# temp, app = Application::TemperatureSensor.factory({'degree'=>-35})                           # Frost
# temp, app = Application::TemperatureSensor.factory({'degree'=>53})                            # Hot
# temp, app = Application::TemperatureSensor.factory({'degree'=>-51})                           # Very Frost
# temp, app = Application::TemperatureSensor.factory({'degree'=>10})                            # Cold

##########################################
# Test EXCLUSION (OK)
##########################################
# Config:
# "Temperature": {
#     "xor": []
# },
# "Gps": {
#     "xor": []
# },
# "Europe": {
#     "exclusion": [
#         "Frost"
#     ]
# }
##########################################
# temp, app = Application::TemperatureSensor.factory({'degree'=>-10})                           # Frost
# temp, app = Application::GpsSensor.factory({'latitude'=>50, 'longitude'=>28})                 # Europe
# temp, app = Application::TemperatureSensor.factory({'degree'=>35})                            # Hot
# temp, app = Application::GpsSensor.factory({'latitude'=>50, 'longitude'=>28})                 # Europe
# temp, app = Application::TemperatureSensor.factory({'degree'=>10})                            # Cold
# temp, app = Application::TemperatureSensor.factory({'degree'=>-35})                           # Frost

##########################################
# Test REQUIREMENT (OK)
##########################################
# Config:
# "Temperature": {
#     "xor": []
# },
# "Gps": {
#     "xor": []
# },
# "Normal": {
#     "requirement": [
#         "Europe"
#     ]
# }
##########################################
# temp, app = Application::TemperatureSensor.factory({'degree'=>19})                            # Normal
# temp, app = Application::GpsSensor.factory({'latitude'=>50, 'longitude'=>28})                 # Europe
# temp, app = Application::TemperatureSensor.factory({'degree'=>19})                            # Normal
# temp, app = Application::TemperatureSensor.factory({'degree'=>35})                            # Hot
# temp, app = Application::TemperatureSensor.factory({'degree'=>19})                            # Normal
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown

##########################################
# Test CAUSALITY 1 (OK) 
##########################################
# Config:
# "Brightness": {
#     "xor": []
# },
# "Other": {
#     "xor": []
# },
# "OtherB": {
#     "causality": [
#         "High Brightness"
#     ]
# }
##########################################
# temp, app = Application::BrightnessSensor.factory({'intensity'=>98})                          # High Brightness
# temp, app = Application::BrightnessSensor.factory({'intensity'=>9})                           # Low Brightness
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'a'})                                 # OtherA
# temp, app = Application::BrightnessSensor.factory({'intensity'=>98})                          # High Brightness
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'a'})                                 # OtherA

##########################################
# Test CAUSALITY 2 (OK) 
##########################################
# Config:
# "OtherB": {
#     "causality": [
#         "High Brightness"
#     ]
# }
##########################################
# temp, app = Application::BrightnessSensor.factory({'intensity'=>98})                          # High Brightness
# temp, app = Application::BrightnessSensor.factory({'intensity'=>9})                           # Low Brightness
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'a'})                                 # OtherA
# temp, app = Application::BrightnessSensor.factory({'intensity'=>98})                          # High Brightness
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::OtherSensor.factory({'letter'=>'a'})                                 # OtherA

##########################################
# Test IMPLICATION 1 (OK)
##########################################
# Config:
# "Unknown": {
#     "implication": [
#         "OtherA"
#     ]
# }
##########################################
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown
# temp, app = Application::GpsSensor.factory({'latitude'=>50, 'longitude'=>4})                  # Unknown
# temp, app = Application::OtherSensor.factory({'letter'=>'a'})                                 # OtherA
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown
# temp, app = Application::OtherSensor.factory({'letter'=>'b'})                                 # OtherB

##########################################
# Test IMPLICATION 2 (OK)
##########################################
# Config:
# "Hot": {
#     "exclusion": [
#         "OtherA"
#     ]
# },
# "Unknown": {
#     "implication": [
#         "OtherA"
#     ]
# }
##########################################
# temp, app = Application::TemperatureSensor.factory({'degree'=>35})                            # Hot
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown

##########################################
# Test IMPLICATION 3 (OK)
##########################################
# Config:
# "Temperature": {
#     "xor": []
# },
# "Hot": {
#     "causality": [
#         "OtherA"
#     ]
# },
# "Unknown": {
#     "implication": [
#         "OtherA"
#     ]
# }
##########################################
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown
# temp, app = Application::GpsSensor.factory({'latitude'=>-50, 'longitude'=>-4})                # Unknown
# temp, app = Application::TemperatureSensor.factory({'degree'=>35})                            # Hot
# temp, app = Application::TemperatureSensor.factory({'degree'=>20})                            # Normal
