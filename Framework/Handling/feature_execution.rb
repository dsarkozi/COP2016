require 'singleton'

require_relative '../Utils/logger'
require_relative '../Application/config'

# apps = Dir.glob('../../*').select { 
#   |f| 
#   File.directory?(f) && f.include?("App") 
# }
# apps.each { 
#   |app|  
#   require_relative "#{app}/Application/features/main"
# }
#require_relative "../../#{Application::Config.instance.appName}/Application/classes/main"
#require_relative '../../AppERS/Application/features/main'


# Class FeatureExecution in module Handling
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Handling

  class FeatureExecution

    include Singleton, Logging

    def execute(o, featuresTransitionsToActivate, featuresTransitionsToDeactivate)
        if o
            #currentApp = Application::Config.instance.currentApp
            #currentApp.removeFeatureTransitions(featuresTransitionsToDeactivate)
            #currentApp.addFeaturesTransitions(o, featuresTransitionsToActivate)
            #Application::Config.instance.setApp(currentApp)
            #currentApp

            featureCounters = Application::FeatureDefinition.instance.activedFeaturesCounters
            current = featureCounters.getActivedEntities
            #Application::Config.instance.currentApp
            current
        else
            # Default feature
            #appModule = Application.const_get(Application::Config.instance.appName)
            #app = appModule.const_get('Main').new()
            #app.addFeaturesTransitions(o, featuresTransitionsToActivate)
            #Application::Config.instance.setApp(app)
            #app

            featureCounters = Application::FeatureDefinition.instance.activedFeaturesCounters
            current = featureCounters.getActivedEntities
            #Application::Config.instance.currentApp
            current
        end
    end
    
  end

end