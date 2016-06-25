require 'singleton'

require_relative 'feature_activation'
require_relative '../Application/feature_definition'
require_relative '../Utils/logger'
require_relative '../Utils/Exceptions/mapping_context_feature_exception'

# Class FeatureSelection in module Handling
#
# authors Duhoux Benoît
# Version 2016

module Handling

  class FeatureSelection

    include Singleton, Logging

    def createContextsFeaturesMapping(appName)
      pathJson = "#{File.dirname(__FILE__)}/../../#{appName}/Application/context_feature_mapping.json"
      file = IO.read(pathJson)
      @contextsFeaturesMapping = JSON.parse(file)
    end

    def select(o, managedContexts)
      newActivedContexts, newDeactivedContexts = getChangedContexts(managedContexts)

      featuresToActivate = selectFeatures(getMoreSpecificFeatures(newActivedContexts))
      featuresToDeactivate = selectFeatures(getMoreSpecificFeatures(newDeactivedContexts))
      logger.debug { "Can activate features ? #{featuresToActivate.map { |feature| feature }} ? ..." }
      logger.debug { "Can deactivate features ? #{featuresToDeactivate.map { |feature| feature }} ? ..." }

      featuresToActivate = Application::FeatureDefinition.instance.getListOfEntitiesGraph(featuresToActivate)
      featuresToDeactivate = Application::FeatureDefinition.instance.getListOfEntitiesGraph(featuresToDeactivate)

      featuresToDeactivate += selectParentsOfNewFeatures(featuresToActivate)

      FeatureActivation.instance.activate(o, featuresToActivate, featuresToDeactivate)
    end

    def selectDefault(defaultContext)
      defaultFeature = selectFeatures([defaultContext])
      defaultFeature = Application::FeatureDefinition.instance.getEntitiesGraph(defaultFeature.first)
      FeatureActivation.instance.activateDefault(defaultFeature)
    end

    private 

    def initialize 
      @contextsFeaturesMapping = nil
    end

    def getChangedContexts(managedContexts)
      contextsUniqueActived, contextsActived, contextsDeactived = getListsContexts(managedContexts)
      newActivedContexts = getNewActivedContexts(contextsUniqueActived, contextsActived)
      newDeactivedContexts = contextsDeactived - newActivedContexts
      newActivedContexts -= newDeactivedContexts
      return newActivedContexts, newDeactivedContexts
    end

    def getListsContexts(managedContexts)
      contextsUniqueActived = managedContexts[:unique]
      contextsUniqueActived ||= []
      contextsActived = managedContexts[:activated]
      contextsActived ||= []
      contextsDeactived = managedContexts[:deactivated]
      contextsDeactived ||= []
      [contextsUniqueActived, contextsActived, contextsDeactived]
    end

    def getNewActivedContexts(unique, actived) 
      newActivedContexts = unique
      actived.each { 
        |activedContext|  
        if !(unique.include? activedContext)
          newActivedContexts << activedContext
        else
          if !(newActivedContexts.include? activedContext)
            newActivedContexts << activedContext
          end
        end
      }
      newActivedContexts
    end

    def selectParentsOfNewFeatures(features)
      alreadyActived = Application::FeatureDefinition.instance.activedFeaturesCounters.getActivedEntities
      featuresToDeactivate = []
      features.each { 
        |feature|
        parents = feature.getAllSuperEntities
        intersection = parents & alreadyActived
        if !(intersection.empty?)
          featuresToDeactivate += intersection
        end
      }
      featuresToDeactivate
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

    def selectFeatures(listContexts)
      features = []
      listContexts.each { 
        |context|
        if !context.isAbstract
          if !(@contextsFeaturesMapping[context.name])
            raise Exceptions::MappingContextFeatureException, "No mapping between #{context.name} and its feature in context_feature_mapping.json"
          end
          features << @contextsFeaturesMapping[context.name]  
        end
      }
      features
    end

  end

end