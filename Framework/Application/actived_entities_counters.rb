# Class ActivedEntitiesCounters in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class ActivedEntitiesCounters

    attr_reader :activedEntities

    def initialize(activedEntities={})
      @activedEntities = activedEntities
    end

    def increaseCounter(entity, times=1)
      if @activedEntities[entity]
        @activedEntities[entity] = @activedEntities[entity] + times
      else
        @activedEntities[entity] = times
      end
    end

    def decreaseCounter(entity, times=1)
      if @activedEntities[entity]
        @activedEntities[entity] = @activedEntities[entity] - times
        if @activedEntities[entity] <= 0
          @activedEntities.delete(entity)
        end
      end
    end

    def getActivedEntities
      return @activedEntities.keys if @activedEntities
      []
    end

    def getCounter(entity)
      return @activedEntities[entity] if @activedEntities[entity]
      0 
    end

    def clone
      activedEntities = @activedEntities.clone
      ActivedEntitiesCounters.new(activedEntities)
    end

    def to_s
      toString = "["
      @activedEntities.each { 
        |activedEntities, counter|
        toString << "#{activedEntities.name} (#{counter}x),"
      }
      toString.chop! if !(@activedEntities.empty?)
      toString << "]"
      toString
    end

  end

end