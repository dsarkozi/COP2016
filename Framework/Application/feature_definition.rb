require 'singleton'
require_relative 'actived_entities_counters'
require_relative 'feature'
require_relative 'entity_definition'
require_relative 'parser'

# Class FeatureDefinition in module Application
#
# authors Duhoux Benoît
# Version 2016

module Application

  class FeatureDefinition < EntityDefinition

    include Singleton

    attr_reader :activedFeaturesCounters

    @@name_default = "FDefault"

    def createFeaturesGraph(appName)
      path_json = "#{File.dirname(__FILE__)}/../../#{appName}/Application/feature_declarations.json"
      file = IO.read(path_json)
      jsonData = JSON.parse(file)
      createGraph(@@name_default, jsonData['features'])
      addDependencies(jsonData['dependencies'])
    end

    def createEntity(feature, mapFeatures)
      Feature.new(feature)
    end

    def setActivedFeaturesCounters(activedFeatures)
      @activedFeaturesCounters = activedFeatures
    end

    def getEntitiesGraph(featureName=@@name_default)
      super(featureName)
    end

    def DFS
      queue = [@entitiesGraph]
      while !(queue.empty?)
        featuresGraph = queue.first
        children = featuresGraph.children
        queue = children + queue
        queue.delete(featuresGraph)

        childrenNames = []
        featuresGraph.children.each { 
          |child|
          childrenNames << child.name  
        }
        
        parentsNames = []
        featuresGraph.superEntities.each { 
          |parent|
          parentsNames << parent.name  
        }

        puts "#{featuresGraph} - parents=#{parentsNames} - children=#{childrenNames}"
        if featuresGraph.dependencies
          puts "Dependencies:"
          featuresGraph.dependencies.displayChain
        end
        puts "\n"
      end      
    end

    private

    def initialize
      super
      @activedFeaturesCounters = ActivedEntitiesCounters.new();
    end

  end
  
end