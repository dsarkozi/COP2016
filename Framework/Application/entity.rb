require_relative 'dependency'
require_relative 'causality'
require_relative 'customization'
require_relative 'implication'
require_relative 'xor'
require_relative 'requirement'
require_relative 'exclusion'

require_relative '../Utils/logger'
require_relative '../Utils/string'

# Class Entity in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Entity

    attr_reader :name, :isAbstract, :implicitSuperEntity, :superEntities, :children, :dependencies

    include Logging

    def initialize(name, isAbstract, superEntities=[], children=[])
      @name = name
      @isAbstract = isAbstract
      @implicitSuperEntity = nil
      @superEntities = superEntities
      @children = children
      @dependencies = nil
    end

    def addImplicitParent(implicitParent)
        @implicitSuperEntity = implicitParent
    end

    def addSuperEntities(parents)
      @superEntities << parents if parents
    end

    def getAllImplicitSuperEntities
      allImplicitParents = []
      queue = [self]
      while !(queue.empty?)
        superEntity = queue.pop
        if superEntity
          allImplicitParents << superEntity.implicitSuperEntity
          queue << superEntity.implicitSuperEntity
        end
      end
      allImplicitParents
    end

    def getAllSuperEntities
      allSuperEntities = []
      queue = [self]
      while !(queue.empty?)
        superEntities = queue.pop
        superEntities.superEntities.each { 
          |superEntity|
          allSuperEntities << superEntity
          queue << superEntity
        }
      end
      allSuperEntities
    end

    def addChild(child)
      @children << child if child
    end

    def getAllChildren
      allChildren = []
      queue = self.children.dup
      while !(queue.empty?)
        child = queue.pop
        queue += child.children
        allChildren << child
      end
      allChildren
    end

    def getAllOwnChildren()
      newList = []
      queue = [self]
      contextBase = self
      while !(queue.empty?)
        current = queue.pop
        newList << current if current.getAllImplicitSuperEntities.include? contextBase
        queue += current.children
      end
      newList
    end

    def createDependencies(relation, dependencies)
      o = createObjectDependency(relation, dependencies)

      if @dependencies
        @dependencies = @dependencies.addDependencies(relation, o)
      else
        @dependencies = o
      end
    end

    def canActivate(activedEntities, managedEntities)
      if @dependencies
        @dependencies.canActivate(self, activedEntities, managedEntities)
      else
        logger.debug { "Activate #{@name}" }
        activedEntities.increaseCounter(self)
        if managedEntities[:activated] 
          managedEntities[:activated] += [self]
        else
          managedEntities[:activated] = [self]
        end
      end
    end

    def canDeactivate(activedEntities, managedEntities)
      if @dependencies
        @dependencies.canDeactivate(self, activedEntities, managedEntities)
      else
        logger.debug { "Deactivate #{@name}" }
        activedEntities.decreaseCounter(self)
        if managedEntities[:deactivated] 
          managedEntities[:deactivated] += [self]
        else
          managedEntities[:deactivated] = [self]
        end
      end
    end

    def to_s
      abstractString = "(Abstract) " if @isAbstract
      implicitParent = @implicitSuperEntity.name if @implicitSuperEntity
      implicitParent = "nil" unless @implicitSuperEntity
      "#{@name} #{abstractString} - implicitParent=#{implicitParent}"
    end

    private

    def createObjectDependency(relation, dependencies)
      klass = nil
      o = nil
      begin
        klass = Application.const_get(relation.capitalizeKeepingProperties)
        o = klass.new(dependencies)
      rescue Exception => e
        raise Exception, "No class #{relation} in Application"
      end
      o
    end

  end
  
end