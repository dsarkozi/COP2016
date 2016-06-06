require 'singleton'
require_relative 'actived_context_counter' # TODO replace with generic counter
require_relative 'feature'

# Class FeatureDefinition in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class FeatureDefinition
  
    attr_reader :selectedFeatures, :selectedFeaturesCounters
  
    include Singleton
    
    def selectFeature(feature)
      featureName = feature.name
      if @selectedFeaturesCounters[featureName]
        @selectedFeaturesCounters[featureName].increaseCounter
      else
        @selectedFeaturesCounters[featureName] = ActivedContextCounter.new(feature)
        @selectedFeatures << feature
      end
    end
    
    def unselectFeature(feature)
      featureName = feature.name
      if @selectedFeaturesCounters[featureName]
        @selectedFeaturesCounters[featureName].decreaseCounter
        if @selectedFeaturesCounters[featureName].counterEmpty?
          @selectedFeaturesCounters.delete(featureName)
          @selectedFeatures.delete(feature)
        end
      end
    end
    
    private
    
    def initialize
      @selectedFeaturesCounters = {}
      @selectedFeatures = []
    end
    
  end
  
end