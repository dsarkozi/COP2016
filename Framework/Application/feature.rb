require_relative 'entity'

# Class Feature in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Feature < Entity
	
    def initialize(name, isAbstract, superFeatures=[], children=[])
        super(name, isAbstract, superFeatures, children)
    end
		
  end

end