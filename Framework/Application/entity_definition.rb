require_relative 'entity'

# Class EntityDefinition in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class EntityDefinition

    def manageExplicitParents(entity, superEntitiesJson, superEntitiesMap)
    end

    def createEntity(entity, mapEntities)
    end

    def manageSpecificThings(entityObject, condition)
    end

    def getEntitiesGraph(nameEntity)
      queue = [@entitiesGraph]
      while(!(queue.empty?)) 
        entitiesGraph = queue.pop
        return entitiesGraph if entitiesGraph.name.downcase.eql? nameEntity.downcase
        queue += entitiesGraph.children
      end
      # TODO instead of nil -> raise exception for programmer
      nil
    end

    def addDependencies(json)
      queue = [@entitiesGraph]
      visited = []

      while(!(queue.empty?)) 
        entitiesGraph = queue.pop
        entityName = entitiesGraph.name

        next if visited.include?(entityName)
        visited << entityName

        manageDependencies(entitiesGraph, json[entityName]) if json[entityName]

        queue += entitiesGraph.children
      end
    end

    def getListOfEntitiesGraph(list)
      listEntitiesGraph = []
      list.each { 
        |name|
        listEntitiesGraph << getEntitiesGraph(name)
      }
      listEntitiesGraph
    end

    private

    def initialize
      @entitiesGraph = nil
    end

    def createGraph(default, json)
      jsonMap = {}
      jsonMap[default] = json[default]
      entitiesOrder = [default]
      entitiesGraphMap = {}
      superEntitiesMap = {} # to manage implicit and explicit superentities

      while !(entitiesOrder.empty?)
        entity = entitiesOrder.first
        mapEntities = jsonMap[entity]
  
        # manage subentities        
        subentitiesJson = mapEntities['subentities']
        if subentitiesJson
          subEntitiesKeys = subentitiesJson.keys
          entitiesOrder = subEntitiesKeys + entitiesOrder
          subEntitiesKeys.each {
            |subEntitiesKey|
            superEntitiesMap[subEntitiesKey] = [entity]
            jsonMap[subEntitiesKey] = subentitiesJson[subEntitiesKey]
          }
        end

        # manage explicit superEntities
        manageExplicitParents(entity, mapEntities['superentities'], superEntitiesMap)

        entityObject = createEntity(entity, mapEntities)

        # link children with their implicit parent
        parents = superEntitiesMap[entity]
        parentObject = entitiesGraphMap[parents.first] if parents
        entityObject.addImplicitParent(parentObject)
        # link children with theirs parents et vice-versa
        parents.each { 
          |parent|
          parentObject = entitiesGraphMap[parent]
          entityObject.addSuperEntities(parentObject)
          parentObject.addChild(entityObject)
        } if parents
        superEntitiesMap.delete(entity)
        
        manageSpecificThings(entityObject, mapEntities['condition'])

        entitiesGraphMap[entity] = entityObject
        jsonMap.delete(entity)
        entitiesOrder.delete(entity)
      end

      @entitiesGraph = entitiesGraphMap[default]
    end
    
    def getAllChildren(listEntitiesGraph)
      newList = []
      listEntitiesGraph.each {
        |entitiesGraph|
        newList += entitiesGraph.getAllChildren  
      }
      newList
    end

    def manageDependencies(entity, dependencies)
      dependenciesHash = getHashDependencies(entity, dependencies)

      relation = 'xor'
      if dependenciesHash[relation]
        manageXorDependencies(entity, dependenciesHash[relation]) 
        dependenciesHash.delete(relation)
      end

      relation = 'exclusion'
      if dependenciesHash[relation]
        manageExclusionDependencies(entity, dependenciesHash[relation]) 
        dependenciesHash.delete(relation)
      end

      relation = 'requirement'
      if dependenciesHash[relation]
        manageSemiBidirectionalDependencies(relation, entity, dependenciesHash[relation]) 
        dependenciesHash.delete(relation)
      end

      relation = 'implication'
      if dependenciesHash[relation]
        manageSemiBidirectionalDependencies(relation, entity, dependenciesHash[relation]) 
        dependenciesHash.delete(relation)
      end

      relation = 'causality'
      if dependenciesHash[relation]
        manageCausalityDependencies(entity, dependenciesHash[relation]) 
        dependenciesHash.delete(relation)
      end
    end

    def getHashDependencies(entity, dependencies)
      dependenciesHash = {}
      dependencies.each { 
        |relation, list|

        listDependencies = []
        if relation.eql? "xor"
          listDependencies << entity
        else  
          listDependencies = getListOfEntitiesGraph(list)
        end

        dependenciesHash[relation] = listDependencies
      }
      dependenciesHash
    end

    def manageXorDependencies(entity, dependencies)
      entity.createDependencies("xor", dependencies)

      children = entity.children # only direct children
      createDep("xor", children, children)
    end

    def createDep(relation, from, to)
      from.each { 
        |fromEntity|
        fromEntity.createDependencies(relation, to)
      }
    end

    def manageExclusionDependencies(entity, dependencies)
      createDep("exclusion", [entity], dependencies)
      createDep("exclusion", dependencies, [entity])
    end

    def manageCausalityDependencies(entity, dependencies)
      entity.createDependencies("causality", dependencies)
    end

    def manageSemiBidirectionalDependencies(relation, entity, dependencies)
      entity.createDependencies(relation, dependencies)
      createDep(relation, dependencies, [])
    end

  end
  
end