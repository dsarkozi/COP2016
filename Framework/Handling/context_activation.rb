require 'singleton'

require_relative 'feature_selection'
require_relative '../Application/context_definition'
require_relative '../Application/actived_entities_counters'
require_relative '../Utils/logger'
require_relative '../Utils/hash'
require_relative '../Utils/Exceptions/dependency_exception'

# Class ContextActivation in module Handling
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Handling

  class ContextActivation

    include Singleton, Logging

    def activate(o, contexts)
      logger.debug { "Can activate contexts ? #{contexts.map { |context| context.name }} ? ..." }
      
      activedContextsCounters = Application::ContextDefinition.instance.activedContextsCounters
      logger.debug { "Old activate contexts : #{activedContextsCounters}" }

      activedContexts = activedContextsCounters.clone
      defaultContext = Application::ContextDefinition.instance.getEntitiesGraph
      if activedContexts.getActivedEntities.include? defaultContext
        activedContexts.decreaseCounter(defaultContext)
      end

      managedContexts = {}
      begin
        contexts.each { 
          |context|
          context.canActivate(activedContexts, managedContexts)  
        }
        Application::ContextDefinition.instance.setActivedContextCounters(activedContexts)
      rescue Exceptions::DependencyException => e
        logger.debug { "Impossible to (de)activate contexts : #{e}" }
        raise Exceptions::DependencyException, e
      end

      activedContextsCounters = Application::ContextDefinition.instance.activedContextsCounters
      logger.debug { "New activate contexts : #{activedContextsCounters}" }
      
      FeatureSelection.instance.select(o, managedContexts)
    end

    def activateDefault(defaultContext)
      activedContexts = Application::ActivedEntitiesCounters.new()
      activedContexts.increaseCounter(defaultContext)
      Application::ContextDefinition.instance.setActivedContextCounters(activedContexts)
      activedContextsCounters = Application::ContextDefinition.instance.activedContextsCounters
      logger.debug { "New activate contexts : #{activedContextsCounters}" }
      FeatureSelection.instance.selectDefault(defaultContext)
    end

  end

end