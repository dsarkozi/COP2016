require_relative 'filter'

# Class ExistsFilter
#
# authors Duhoux Benoît
# version 2016

module Application

  # Filter data according time
  class ExistsFilter < Filter

    def initialize
      @list = []
    end

    def exists?(attribute)
      @list.include?(attribute)
    end

  end

end