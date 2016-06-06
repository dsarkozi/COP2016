require_relative '../Utils/logger'
require_relative 'feature_definition_mockup'

# Method proceed in module Application::Features
#
# authors Duhoux Benoît
# Version 2016

module Application

	module Features

		module Proceed 

			include Logging

			def proceedUI(lastCall=true)
				featureName = self.class.name.split("::")[-2]
				featureGraph = FeatureDefinition.instance.getEntitiesGraph(featureName)
				parent = featureGraph.implicitSuperEntity
				appName = Application::Config.appName
				moduleObject = Application.const_get(appName).const_get('Features').const_get(parent.name)
				o = moduleObject.const_get("Gui").new()
				o.createUI(lastCall)
			end
			
		end

	end

end