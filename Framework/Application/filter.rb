require 'singleton'

# Baseclass Filter in module Application
# 
# authors Duhoux Benoît and Sarkozi David
# version 2015

module Application

  class Filter

		include Singleton
		
		def filter(o)
			# must be override
		end

  end

end
