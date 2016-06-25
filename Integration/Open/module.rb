module M
	def self.bar
		puts "I'm M bar !"
	end
	
	def self.foo
		puts "I am M foo"
	end
	
	def self.get_foobar
		puts foobar
	end
end

module D
	def self.bar
		puts "I'm D bar !"
	end
	
	def self.foo
		puts "I am D foo"
	end
end

module S
	def self.bar
		puts "I'm S bar !"
	end
	
	def self.foo
		puts "I am S foo"
	end
end
