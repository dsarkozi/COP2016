require_relative '../Utils/logger'
require_relative '../Utils/hash'

require_relative '../Utils/Exceptions/dependency_exception'

# Class Dependency in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Dependency

    include Logging

    attr_accessor :listDependencies, :next

    @@orderPolicy = ["customization", "xor", "exclusion", "requirement", "implication", "causality"]

    def initialize(listDependencies, nextDep=nil)
      @listDependencies = listDependencies
      @next = nextDep
    end

    def addDependencies(relation, o)
      indexRelation = @@orderPolicy.index(relation)

      if indexRelation.nil?
        raise SyntaxError, "No #{relation} relation existing."
      end

      currentPtr = self
      lastPtr = nil
      while currentPtr
        currentRelation = currentPtr.class.name.split("::")[1]
        indexCurrent = @@orderPolicy.index { |rel| rel.downcase == currentRelation.downcase }
        if indexCurrent < indexRelation
          lastPtr = currentPtr
          currentPtr = currentPtr.next
        elsif indexCurrent == indexRelation
          currentPtr.listDependencies |= o.listDependencies
          return self
        else 
          break
        end
      end

      if !lastPtr
        o.next = self
        return o
      else
        o.next = lastPtr.next if lastPtr.next
        lastPtr.next = o
        return self
      end
    end

    def canActivate(currentEntity, activedEntities, managedEntities)
      logger.debug { "Can activate #{currentEntity.name} ?" }
      
      canActivateSpecific(currentEntity, activedEntities, managedEntities)
      @next.canActivate(currentEntity, activedEntities, managedEntities) if @next
    end

    def canDeactivate(currentEntity, activedEntities, managedEntities)
      logger.debug { "Can deactivate #{currentEntity.name} ?" }
      
      canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
      @next.canDeactivate(currentEntity, activedEntities, managedEntities) if @next
    end

    def getChain
      chain = [self]
      ptr = @next
      while ptr
        chain << ptr
        ptr = ptr.next
      end
      chain
    end

    def displayChain
      puts "#{self}"
      @next.displayChain if @next
    end

    def to_s
      "#{self.class}->#{@listDependencies.map { |c| c.name } if @listDependencies}"
    end

    private

    def canActivateSpecific(currentEntity, activedEntities, managedEntities)
    end

    def canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
    end
    
    def addActivedEntity(currentEntity, activedEntities, managedEntities)
      if managedEntities[:unique] && (managedEntities[:unique].include? (currentEntity))
        logger.debug { "#{currentEntity.name} is already actived and can only be actived once." }
        return
      end

      logger.debug { "Activate #{currentEntity.name}" }
      activedEntities.increaseCounter(currentEntity)
      if managedEntities[:activated] 
        managedEntities[:activated] += [currentEntity]
      else
        managedEntities[:activated] = [currentEntity]
      end
    end

    def addUniqueActivedEntity(currentEntity, activedEntities, managedEntities)
      if !(managedEntities[:unique])
        logger.debug { "Activate #{currentEntity.name}" }
        activedEntities.increaseCounter(currentEntity)
        managedEntities[:unique] = [currentEntity]
      else
        if !(managedEntities[:unique].include? (currentEntity))
          logger.debug { "Activate #{currentEntity.name}" }
          activedEntities.increaseCounter(currentEntity)
          managedEntities[:unique] << currentEntity
        end
      end
    end

    def removeActivedEntity(currentEntity, activedEntities, managedEntities)
      logger.debug { "Deactivate #{currentEntity.name}" }
      activedEntities.decreaseCounter(currentEntity)
      if managedEntities[:deactivated] 
        managedEntities[:deactivated] += [currentEntity]
      else
        managedEntities[:deactivated] = [currentEntity]
      end
    end

    def removeActivedEntityInMC(currentEntity, managedEntities)
      managedEntities[:activated].delete(currentEntity) if managedEntities[:activated]
      managedEntities[:unique].delete(currentEntity) if managedEntities[:unique]
    end

    def getDependenciesFromRelation(relationClass, dependenciesChainList)
      dependenciesChainList.each { 
        |dependency|  
        return dependency if dependency.class.name.eql?(relationClass.name)
      }
      return nil
    end

  end
  
end