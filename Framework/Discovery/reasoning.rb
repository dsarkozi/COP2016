require 'singleton'
require 'json'
require_relative '../Application/context_definition'
require_relative '../Handling/context_activation'
require_relative '../Utils/logger'

# Class Reasoning in module Discovery
#
# authors Duhoux Benoît and Sarkozi David
# Version 2015

module Discovery

  # It reasons to create contexts
  class Reasoning

    include Singleton, Logging

    def reason(o)
      logger.debug { "Reason... think..." }
      nameClass = o.class.name

      currentContextsGraph = Application::ContextDefinition.instance.getEntitiesGraph(nameClass)

      if currentContextsGraph
        admissibleContexts = getAdmissibleContexts(currentContextsGraph, o)

        if admissibleContexts.empty?
          logger.debug { "Fail to found a specific context... Default context is selected..." }
          admissibleContexts = [Application::ContextDefinition.instance.getEntitiesGraph]
        end

        return Handling::ContextActivation.instance.activate(o, admissibleContexts)
      end
    end

    def reasonDefault
      defaultContext = Application::ContextDefinition.instance.getEntitiesGraph
      return Handling::ContextActivation.instance.activateDefault(defaultContext)
    end

    private
    
    def initialize
    end

    def getAdmissibleContexts(contextsGraph, o)
      admissibleContexts = []
      queue = [contextsGraph]
      while !(queue.empty?)
        contextsGraph = queue.shift
        isOk = contextsGraph.applyConditions(o)
        admissibleContexts << contextsGraph if isOk
        queue = contextsGraph.children + queue
      end
      admissibleContexts
    end

  end

end
