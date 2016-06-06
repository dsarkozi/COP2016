require 'json'
require_relative '../Discovery/interpretation'

# authors Duhoux Benoît and Sarkozi David
# version 2015

module Application

  # Mixin Observable (pattern-like Observer)
  module Observable

    def set_data(data)
      self.update_state(data)
      notify
    end

    def notify
      Discovery::Interpretation.instance.interpret(self.to_json)
    end

    def to_json
      hash_json = Hash.new()

      regexClassNameSensor = /(.+::)*(.+)/
      classNameSensor = self.class.name
      classNameSensor = regexClassNameSensor.match(classNameSensor).captures.last
      hash_json['sensor'] = classNameSensor
      regexClassName = /(.+)Sensor/
      hash_json['class_name'] = regexClassName.match(classNameSensor).captures.last

      regex_inst_var = /@(.+)/
      inst_vars = self.instance_variables
      inst_vars.each { 
        |inst_var|
        name_var = regex_inst_var.match(inst_var).captures.first
        hash_json[name_var] = self.instance_variable_get(inst_var) 
      }
      
      hash_json.to_json
    end

  end

end