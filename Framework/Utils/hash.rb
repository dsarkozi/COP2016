# Add methods in Hash class
#
# authors Duhoux Benoît and Sarkozi David
# version 2016

class Hash

    def +(map)
    	map.each { 
    		|k, v|
    		if self[k]
    			self[k] += v
    		else
    			self[k] = v
    		end  
    	}
    	self
    end

end