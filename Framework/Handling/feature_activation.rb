require 'singleton'

# require_relative 'feature_execution_mockup'
require_relative 'transition_selection'
require_relative '../Application/feature_definition'
require_relative '../Utils/logger'
require_relative '../Utils/hash'
require_relative '../Utils/Exceptions/dependency_exception'

# Class FeatureActivation in module Handling
#
# authors Duhoux Benoît
# Version 2016

module Handling

  class FeatureActivation

    include Singleton, Logging

    def activate(o, featuresToActivate, featuresToDeactivate)
      logger.debug { "Can activate features ? #{featuresToActivate.map { |feature| feature.name }} ? ..." }
      logger.debug { "Can deactivate features ? #{featuresToDeactivate.map { |feature| feature.name }} ? ..." }
      
      activedFeaturesCounters = Application::FeatureDefinition.instance.activedFeaturesCounters
      logger.debug { "Old activate features : #{activedFeaturesCounters}" }

      managedFeatures = {}

      activedFeatures = activedFeaturesCounters.clone
      defaultFeature = Application::FeatureDefinition.instance.getEntitiesGraph
      if activedFeatures.getActivedEntities.include? defaultFeature
        activedFeatures.decreaseCounter(defaultFeature)
        managedFeatures = {:deactivated => [defaultFeature]}
      end

      begin
        featuresToDeactivate.each { 
          |feature|
          feature.canDeactivate(activedFeatures, managedFeatures)  
        }
        featuresToActivate.each { 
          |feature|
          feature.canActivate(activedFeatures, managedFeatures)  
        }
        Application::FeatureDefinition.instance.setActivedFeaturesCounters(activedFeatures)
      rescue Exceptions::DependencyException => e
        logger.debug { "Impossible to (de)activate features : #{e}" }
      end

      activedFeaturesCounters = Application::FeatureDefinition.instance.activedFeaturesCounters
      logger.debug { "New activate features : #{activedFeaturesCounters}" }
      
      TransitionSelection.instance.select(o, managedFeatures)
    end

    def activateDefault(defaultFeature)
      activedFeatures = Application::ActivedEntitiesCounters.new()
      activedFeatures.increaseCounter(defaultFeature)
      Application::FeatureDefinition.instance.setActivedFeaturesCounters(activedFeatures)
      activedFeaturesCounters = Application::FeatureDefinition.instance.activedFeaturesCounters
      logger.debug { "New activate features : #{activedFeaturesCounters}" }
      TransitionSelection.instance.select(nil, {:activated => [defaultFeature]})
    end

  end

end