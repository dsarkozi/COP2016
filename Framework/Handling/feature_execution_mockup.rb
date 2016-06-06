require 'singleton'

require_relative '../Utils/logger'
require_relative '../Application/Config'

# apps = Dir.glob('../../*').select { 
#   |f| 
#   File.directory?(f) && f.include?("App") 
# }
# apps.each { 
#   |app|  
#   require_relative "#{app}/Application/features/main"
# }
require_relative '../../AppTestExecution/Application/features/main'
require_relative '../../AppERS/Application/features/main'


# Class FeatureExecution in module Handling
#
# authors Duhoux Benoît
# Version 2016

module Handling

  class FeatureExecution

    include Singleton, Logging

    def execute(o, featuresTransitionsToActivate, featuresTransitionsToDeactivate)
        if o
            currentApp = Application::Config.instance.currentApp
            currentApp.removeFeatureTransitions(featuresTransitionsToDeactivate)
            currentApp.addFeaturesTransitions(o, featuresTransitionsToActivate)
            Application::Config.instance.setApp(currentApp)
            currentApp
        else
            # Default feature
            appModule = Application.const_get(Application::Config.instance.appName)
            app = appModule.const_get('Main').new()
            app.addFeaturesTransitions(o, featuresTransitionsToActivate)
            Application::Config.instance.setApp(app)
            app
        end
    end
    
  end

end