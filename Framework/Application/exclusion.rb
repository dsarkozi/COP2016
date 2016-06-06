require_relative 'dependency'

require_relative '../Utils/Exceptions/exclusion_exception'

# Class Exclusion in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Exclusion < Dependency

    private

    def canActivateSpecific(currentEntity, activedEntities, managedEntities)
      intersection = @listDependencies & activedEntities.getActivedEntities
      if activedEntities.getActivedEntities.empty?
        addActivedEntity(currentEntity, activedEntities, managedEntities)
      else
        if !(intersection.empty?)
          removeActivedEntityInMC(currentEntity, managedEntities)
          raise Exceptions::ExclusionException, "Activation of #{currentEntity.name} cannot be done due to exclusion with #{intersection.map { |entity| entity.name }}"
        end
        
        if !managedEntities[:activated] || !(managedEntities[:activated].include? currentEntity)
          addActivedEntity(currentEntity, activedEntities, managedEntities)
        end
      end
    end

    def canDeactivateSpecific(currentEntity, activedEntities, managedEntities)
      if activedEntities.getActivedEntities.include?(currentEntity)
        removeActivedEntity(currentEntity, activedEntities, managedEntities)
      end
    end

  end
  
end