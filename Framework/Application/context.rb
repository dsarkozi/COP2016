require_relative 'condition_tree'
require_relative 'entity'
require_relative '../Utils/logger'

# Class Context in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class Context < Entity

    attr_reader :sensors, :conditionTree

    def initialize(name, isAbstract, compositionOrder, sensors=[], superContexts=[], children=[])
      super(name, isAbstract, superContexts, children)
      @compositionOrder = compositionOrder
      @sensors = sensors
      @conditionTree = nil
    end

    def addConditions(conditions)
      @conditionTree = ConditionsTree.createConditionsTree(conditions, sensors)
    end

    def addParentsSensors
      parentsSensors = getSensorsFromParents()
      @sensors |= parentsSensors if parentsSensors
    end

    def getSensorsFromParents
      parentsSensors = []
      queue = self.superEntities.dup
      while !(queue.empty?)
        context = queue.pop
        parentsSensors |= context.sensors
        queue += context.superEntities
      end
      parentsSensors
    end

    def applyConditions(o)
      return @conditionTree.applyConditions(o, @sensors) if @conditionTree
      true
    end

    def to_s
      abstractString = "(Abstract) " if @isAbstract
      sensorsString = @sensors.to_s if @sensors
      sensorsString = "[]" unless @sensors
      compositionString = @compositionOrder.to_s if @compositionOrder
      compositionString = "[]" unless @compositionOrder
      "#{super} - sensors=#{sensorsString} - compositionOrder=#{compositionString}"
    end

  end
  
end