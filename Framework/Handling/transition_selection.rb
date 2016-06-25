require 'singleton'

require_relative 'feature_execution'
require_relative '../Application/feature_definition'
require_relative '../Utils/logger'
require_relative '../Utils/Exceptions/dependency_exception'

# Class TransitionSelection in module Handling
#
# authors Duhoux Benoît
# Version 2016

module Handling

  class TransitionSelection

    include Singleton, Logging

    def createTransitionMapping(appName)
      pathJson = "#{File.dirname(__FILE__)}/../../#{appName}/Application/transition_mapping.json"
      file = IO.read(pathJson)
      @transitionMapping = JSON.parse(file) 
    end

    def select(o, managedFeatures)
      featuresToActivate, featuresToDeactivate = getFeatures(managedFeatures)
      featuresToActivate = getMoreSpecificFeatures(featuresToActivate)
      featuresToDeactivate = getMoreSpecificFeatures(featuresToDeactivate)

      featuresTransitionsToActivate = getFeaturesTransitions(featuresToActivate, :activated)
      featuresTransitionsToDeactivate = getFeaturesTransitions(featuresToDeactivate, :deactivated)
      
      FeatureExecution.instance.execute(o, featuresTransitionsToActivate, featuresTransitionsToDeactivate)
    end

    private

    def initialize
      @transitionMapping = nil      
    end

    def getFeatures(managedFeatures)
      featuresToUnique = managedFeatures[:unique]
      featuresToUnique ||= []
      featuresToActivate = managedFeatures[:activated]
      featuresToActivate ||= []
      featuresToDeactivate = managedFeatures[:deactivated]
      featuresToDeactivate ||= []
      return featuresToUnique | featuresToActivate, featuresToDeactivate
    end

    def getFeaturesTransitions(features, action)
      featuresTransitions = {}
      features.each { 
        |feature|
        transition = getMostSpecificTransitions(feature, @transitionMapping[action.to_s])
        featuresTransitions[feature] = transition
      }
      featuresTransitions
    end

    def getMostSpecificTransitions(feature, transitionMapping)
      if !transitionMapping
        return nil
      end
      queue = [feature]
      while !(queue.empty?)
        f = queue.shift
        if transitionMapping.keys.include?(f.name)
          return transitionMapping[f.name]
        end
        queue += f.getAllSuperEntities
      end
      return nil
    end

    def getMoreSpecificFeatures(features)
      specificFeatures = []
      features.each { 
        |feature|
        implicitSuperEntities = feature.getAllSuperEntities
        intersection = specificFeatures & implicitSuperEntities
        if !(intersection.empty?)
          specificFeatures -= intersection
        end
        specificFeatures << feature
      }
      specificFeatures
    end

  end

end