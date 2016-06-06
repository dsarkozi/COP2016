require_relative 'dependency'

# Class Causality in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Causality < Dependency

    private

    def canActivateSpecific(currentEntity, activedEntities, managedEntities)
      if @listDependencies.empty?
        addActivedEntity(currentEntity, activedEntities, managedEntities)
      else
        @listDependencies.each { 
          |entity|
          entity.canActivate(activedEntities, managedEntities)
        }
        addActivedEntity(currentEntity, activedEntities, managedEntities)
      end
    end

    def canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
      if @listDependencies.empty?
        removeActivedEntity(currentEntity, activedEntities, managedEntities)
        canDeactivateMore(currentEntity, activedEntities, managedEntities)
      else
        @listDependencies.each { 
          |entity|  
          entity.canDeactivate(activedEntities, managedEntities)
        }
      end
    end

    def canDeactivateMore(currentEntity, activedEntities, managedEntities)
    end

  end
  
end