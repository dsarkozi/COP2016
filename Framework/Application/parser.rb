require 'json'
require_relative 'context_definition'
require_relative 'feature_definition'

# Class  in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Parser

    def self.parseContextDeclarations(appName)
      ContextDefinition.instance.createContextsGraph(appName)
    end

    def self.parseFeatureDeclarations(appName)
      FeatureDefinition.instance.createFeaturesGraph(appName)
    end

  end
  
end