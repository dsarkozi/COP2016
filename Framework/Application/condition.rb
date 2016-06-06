require_relative '../Utils/string'

# Class Condition in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Condition
    
    attr_reader :fromSensor, :on, :operator, :value

    def initialize(conditionString, sensors)
      @on, @operator, @value = conditionString.split
      @fromSensor, @on = @on.split('.')
      raise SyntaxError, "Wrong sensors (sensors not inherited) in JSON file of declarations for #{conditionString}" if !(sensors.include? @fromSensor)
      @value = @value.to_f if @value.is_f?
    end

    def apply(o, parentsSensors)
      raise RuntimeError, "Object comes from wrong sensors" if !(parentsSensors.include? o.sensor)

      onAttribute = "@" << @on
      if o.instance_variables.include? onAttribute.to_sym
        inst_var = o.instance_variable_get("#{onAttribute}")
        result = inst_var.send(operator, value)
      else
        result_method = o.send(@on)
        result = result_method.send(operator, value)
      end
    end

    def to_s
      "#{@fromSensor}.#{@on}\t#{@operator}\t#{@value}"
    end

  end

end