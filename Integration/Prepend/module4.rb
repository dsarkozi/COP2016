module M
	module Msingle
		def bar
			puts "Single M bar"
		end
	end
	
	def slow
		puts "I'm M bar !"
	end
	
	def bar
	end
	
	def bidule
		puts "bidule"
	end
	
	def self.prepended(base)
		class << base
			prepend Msingle
		end
	end
end

module D
	def slow
		puts "I'm D bar !"
	end
end
