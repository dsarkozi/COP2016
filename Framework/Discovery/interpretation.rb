require 'singleton'
require 'json'

require_relative 'reasoning'
require_relative 'sensor'
require_relative '../Application/Config'
require_relative '../Utils/logger'
require_relative '../Utils/Exceptions/filter_exception'
# apps = Dir.glob('../../*').select { 
#   |f| 
#   File.directory?(f) && f.include?("App") 
# }
# apps.each { 
#   |app|  
#   require_relative "#{File.dirname(__FILE__)}/#{app}/Application/my_filters"
# }
require_relative "../../AppTestExecution/Application/my_filters"
require_relative "../../AppERS/Application/my_filters"

# Class Interpretation in module Discovery
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Discovery
  
  # It filters and parses the rawdata to send to the reasoning  
  class Interpretation
        
    include Singleton, Logging

    def interpret(json)
      hash_data = JSON.parse(json)
      class_name = hash_data['class_name']

      object = parser(hash_data)
      if filter(class_name, object)
        logger.debug { "Interpret raw data : #{json}" }
        Reasoning.instance.reason(object)
      else
        raise Exceptions::FilterException, "No data filter due to filters"
      end
    end
  
    def interpretDefault
      Reasoning.instance.reasonDefault
    end

    private

    def filter(class_name, o)
      appName = Application::Config.instance.appName
      filter_class_name = class_name << "Filter"
      filter_class_exists = Application.const_get(appName).const_defined?(filter_class_name)

      if filter_class_exists
        filter_class = Application.const_get(appName).const_get(filter_class_name)
        return filter_class.instance.filter(o)
      else
        raise Exceptions::FilterException, "No filter existing."
      end
      return false
    end

    def parser(hash_data)
      sensor = hash_data['sensor']
      hash_data.delete('sensor')

      class_name = hash_data['class_name']
      hash_data.delete('class_name')

      create_instance(sensor, class_name, hash_data)
    end

    def create_instance(sensor, class_name, attributes)
      new_class = create_class(class_name)
      new_class.new(sensor, attributes)
    end

    def create_class(class_name)
      if Object.const_defined?(class_name)
        return Object.const_get(class_name)
      else 
        return Object.const_set(class_name,
          Class.new(Sensor) do
            def initialize(sensor, attributes)
              super(sensor)
              attributes.each { 
                |name, value|
                self.class.send(:attr_accessor, name.to_sym)
                instance_variable_set("@#{name.to_sym}", value)
              }
            end
          end  
        )
      end 
    end

  end

end