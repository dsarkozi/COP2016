require_relative 'dependency'

require_relative '../Utils/Exceptions/requirement_exception'

# Class Requirement in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Requirement < Dependency

    private

  	def canActivateSpecific(currentEntity, activedEntities, managedEntities)
      difference = @listDependencies - activedEntities.getActivedEntities
      if difference.empty?
        if !managedEntities[:activated] || !(managedEntities[:activated].include? currentEntity)
          addActivedEntity(currentEntity, activedEntities, managedEntities)
        end
      else
        removeActivedEntityInMC(currentEntity, managedEntities)
        raise Exceptions::RequirementException, "Activation of #{currentEntity.name} cannot be done due to requirement with #{difference.map { |entity| entity.name }}"
      end
    end

    def canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
      if activedEntities.getActivedEntities.include? currentEntity
        removeActivedEntity(currentEntity, activedEntities, managedEntities)
      end
      activedEntities.getActivedEntities.each { 
        |activedEntity|  
        if activedEntity.dependencies
          dependenciesChain = activedEntity.dependencies.getChain
          requirement = getDependenciesFromRelation(self.class, dependenciesChain)
          if requirement && (requirement.listDependencies.include? currentEntity)
            activedEntity.canDeactivate(activedEntities, managedEntities)
          end
        end
      }
    end

  end
  
end