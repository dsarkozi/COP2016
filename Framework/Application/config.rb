require 'singleton'
require_relative '../Application/context_definition'
require_relative '../Application/feature_definition_mockup'
require_relative '../Discovery/interpretation'
require_relative '../Handling/feature_selection_mockup'
require_relative '../Handling/transition_selection'

# Class Config in module Application
#
# authors Duhoux Benoît
# version 2016

module Application
  
  class Config
    
    include Singleton

    attr_reader :appName, :currentApp

    def startup(appName)
      @appName = appName
      ContextDefinition.instance.createContextsGraph(appName)
      FeatureDefinition.instance.createFeaturesGraph(appName)
      Handling::FeatureSelection.instance.createContextsFeaturesMapping(appName)
      Handling::TransitionSelection.instance.createTransitionMapping(appName)

      Discovery::Interpretation.instance.interpretDefault
    end

    def setApp(app)
      @currentApp = app
    end

    private 

    def initialize
      @currentApp = nil
      @appName = ""
    end

  end

end