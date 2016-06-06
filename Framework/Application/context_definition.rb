require 'singleton'
require_relative 'actived_entities_counters'
require_relative 'context'
require_relative 'entity_definition'

# Class ContextDefinition in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class ContextDefinition < EntityDefinition

    attr_reader :activedContextsCounters

    include Singleton

    @@name_default = "Default"

    def createContextsGraph(appName)
      path_json = "#{File.dirname(__FILE__)}/../../#{appName}/Application/context_declarations.json"
      file = IO.read(path_json)
      jsonData = JSON.parse(file)
      createGraph(@@name_default, jsonData['contexts'])
      addDependencies(jsonData['dependencies'])
    end

    def manageExplicitParents(context, superContextsJson, superContextsMap)
      if superContextsJson
        if superContextsMap[context]
          superContextsMap[context] = superContextsMap[context] + superContextsJson
        else
          superContextsMap[context] = superContextsJson
        end
      end
    end

    def createEntity(context, mapContexts)
      isAbstract = mapContexts['isAbstract']
      sensors = mapContexts['sensors']
      sensors ||= []
      policyOrder = mapContexts['policyOrder']
      Context.new(context, isAbstract, policyOrder, sensors)
    end

    def getEntitiesGraph(contextName=@@name_default)
      super(contextName)
    end

    def manageSpecificThings(contextObject, condition)
      contextObject.addParentsSensors
      contextObject.addConditions(condition)
    end

    def setActivedContextCounters(activedContexts)
      @activedContextsCounters = activedContexts
    end

    def DFS
      queue = [@entitiesGraph]
      while !(queue.empty?)
        contextsGraph = queue.first
        children = contextsGraph.children
        queue = children + queue
        queue.delete(contextsGraph)

        childrenNames = []
        contextsGraph.children.each { 
          |child|
          childrenNames << child.name  
        }
        
        parentsNames = []
        contextsGraph.superEntities.each { 
          |parent|
          parentsNames << parent.name  
        }

        puts "#{contextsGraph} - parents=#{parentsNames} - children=#{childrenNames}"
        if contextsGraph.dependencies
          puts "Dependencies:"
          contextsGraph.dependencies.displayChain
        end
        contextsGraph.conditionTree.DFS if contextsGraph.conditionTree
        puts "\n"
      end      
    end

    private

    def initialize
      super
      @activedContextsCounters = ActivedEntitiesCounters.new();
    end
    
  end
  
end