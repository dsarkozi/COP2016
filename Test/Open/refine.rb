module M
	refine Foo do
		def bar
			puts "I'm M bar !"
		end
	end
end

module D
	refine Foo do
		def bar
			puts "I'm D bar !"
		end
	end
end
