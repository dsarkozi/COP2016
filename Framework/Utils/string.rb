# Add methods in String class
#
# authors Duhoux Benoît and Sarkozi David
# version 2016

class String
    def is_f?
       Float(self) != nil rescue false
    end

    def capitalizeKeepingProperties
    	self.slice(0,1).capitalize + self.slice(1..-1)
    end
end