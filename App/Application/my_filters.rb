require_relative '../../Framework/Application/time_filter'

# Class TimeFilter, TemperatureFilter, GpsFilter in module Aplication
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Application

  module App

    # It accept data each 1 seconds for temperature
    class TemperatureFilter < TimeFilter
      
      def initialize
        super
        @new_wait_to_filter = 0
      end

    end

    # It accept data each second for gps
    class GpsFilter < TimeFilter
      
      def initialize
        super
        @new_wait_to_filter = 0
      end

    end

    # It accept data each 0 second for brightness
    class BrightnessFilter < TimeFilter
      
      def initialize
        super
        @new_wait_to_filter = 0
      end

    end

    # It accept data each 0 second for other
    class OtherFilter < TimeFilter
      
      def initialize
        super
        @new_wait_to_filter = 0
      end

    end

  end
  
end
