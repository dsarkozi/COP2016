require_relative 'filter'

# Class TimeFilter, TemperatureFilter, GpsFilter in module Application
#
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Application

  # Filter data according time
  class TimeFilter < Filter

    def initialize
      @wait_to_filter = 0
      @new_wait_to_filter = 0
      @time_now = Time.now
    end

    def filter(o)
      if Time.now >= @time_now + @wait_to_filter
        @wait_to_filter = @new_wait_to_filter
        @time_now = Time.now
        return true
      else
        return false
      end
    end

  end

end