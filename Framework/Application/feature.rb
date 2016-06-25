require_relative 'entity'
require_relative '../Utils/logger'

# Class Feature in module Application
#
# authors Duhoux Benoît
# Version 2016

module Application

  class Feature < Entity

    def initialize(name, superContexts=[], children=[])
      super(name, false, superContexts, children)
    end

  end
  
end