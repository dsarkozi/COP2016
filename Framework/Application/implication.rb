require_relative 'causality'

# Class Implication in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  # BUGGY
  class Implication < Causality

    private

    def canDeactivateMore(currentEntity, activedEntities, managedEntities)
      activedEntitiesList = activedEntities.getActivedEntities
      if !(activedEntitiesList.include? currentEntity)
        # Inside this condition, infinite loop
        activedEntitiesList.each { 
          |activedEntity|
          if activedEntity.dependencies
            dependenciesChain = activedEntity.dependencies.getChain
            implication = getDependenciesFromRelation(self.class, dependenciesChain)
            if implication && (implication.listDependencies.include? currentEntity)
              counter = activedEntities.getCounter(activedEntity)
              counter.times { 
                activedEntity.canDeactivate(activedEntities, managedEntities)  
              }
            end
          end
        }
      end      
    end

  end
  
end