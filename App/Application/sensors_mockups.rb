require_relative '../../Framework/Application/observable'

# Module representing fake sensors (Temperature, Gps, Other, Brightness)
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Application

  module App
  
    class ApplicationSensor

      include Observable

      def self.factory(data)
        object = self.new(data)
        app = object.notify
        return object, app      
      end

    end

    # It represents a sensor for temperature
    class TemperatureSensor < ApplicationSensor

      attr_reader :degree

      def initialize(data)
        update_state(data)
      end

      def update_state(data)
        @degree = data['degree'].to_f
      end
    end

    # It represents a sensor for gps
    class GpsSensor < ApplicationSensor

      include Observable

      attr_reader :latitude, :longitude

      def initialize(data)
        update_state(data)
      end

      def update_state(data)
        @latitude = data['latitude'].to_f
        @longitude = data['longitude'].to_f
      end
    end

    # It represents a sensor for other
    class OtherSensor < ApplicationSensor

      include Observable

      attr_reader :letter

      def initialize(data)
        update_state(data)
      end

      def update_state(data)
        @letter = data['letter']
      end

    end

    # It represents a sensor for brightness
    class BrightnessSensor < ApplicationSensor

      include Observable

      attr_reader :intensity

      def initialize(data)
        update_state(data)
      end

      def update_state(data)
        @intensity = data['intensity'].to_f
      end

    end
  
  end

end
