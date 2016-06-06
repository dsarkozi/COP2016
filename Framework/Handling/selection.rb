require 'singleton'
require_relative '../Application/feature_definition'
require_relative '../Utils/logger'
require_relative '../Application/context_feature_mapping'

# Feature Selection in module Handling
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Handling

  class Selection
  
    include Singleton, Logging
    
    #TODO To be called in activation.rb before actual (de)activation of contexts
    def select(activatingContexts, deactivatingContexts)
      logger.debug { "Trying to select features from (de)activating contexts #{contexts.map { |context| context.name }}" }
      activeContexts = Application::ContextDefinition.instance.activedContexts
      new_selection = change_feature_selection(activatingContexts, deactivatingContexts, activeContexts)
      toSelect = new_selection[:toSelect]
      toUnselect = new_selection[:toUnselect]
      
      
      
    end
    
    private
    
    def selectFeatures(features)
      features.each {
        |feature|
        logger.debug { "SELECT FEATURE... #{feature.name}" }
        Application::FeatureDefinition.instance.selectFeature(feature)
      }
    end
    
    def unselectFeatures(features)
      features.each {
        |feature|
        logger.debug { "UNSELECT FEATURE... #{feature.name}" }
        Application::FeatureDefinition.instance.unselectFeature(feature)
      }
    end
    
  end
  
end