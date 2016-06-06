require_relative 'dependency'

require_relative '../Utils/Exceptions/xor_exception'

# Class Xor in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Xor < Dependency

    private

    def canActivateSpecific(currentEntity, activedEntities, managedEntities)
      intersection = @listDependencies & activedEntities.getActivedEntities
      if intersection.empty?
        addUniqueActivedEntity(currentEntity, activedEntities, managedEntities)
      else
        if !(intersection.include? currentEntity)
          entitiesToDeactivate = intersection
          intersection.each { 
            |entityToDeactivate|
            entitiesToDeactivate += (activedEntities.getActivedEntities & entityToDeactivate.getAllOwnChildren)
          }
          activateWhenDeactivate(currentEntity, entitiesToDeactivate, activedEntities, managedEntities)
        else
          entitiesWithChildren = [currentEntity] + currentEntity.getAllOwnChildren
          entitiesToDeactivate = entitiesWithChildren & activedEntities.getActivedEntities
          if !(entitiesToDeactivate.empty?)
            activateWhenDeactivate(currentEntity, entitiesToDeactivate, activedEntities, managedEntities)
          else
            removeActivedEntityInMC(currentEntity, managedEntities)
            raise Exceptions::XorException, "Activation error in XOR."
          end
        end
      end
    end

    def activateWhenDeactivate(currentEntity, entitiesToDeactivate, activedEntities, managedEntities)
      entitiesToDeactivate.each { 
        |entityToDeactivate|  
        entityToDeactivate.canDeactivate(activedEntities, managedEntities)
      }

      if (entitiesToDeactivate - managedEntities[:deactivated]).empty?
        addUniqueActivedEntity(currentEntity, activedEntities, managedEntities)
      else
        removeActivedEntityInMC(currentEntity, managedEntities)
        raise Exceptions::XorException, "Activation error in XOR due to another context cannot be deactivated."
      end
    end

    def canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
      if activedEntities.getActivedEntities.include? currentEntity
        removeActivedEntity(currentEntity, activedEntities, managedEntities)
      end
    end

  end
  
end