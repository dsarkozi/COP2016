require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

f = Foo.new
puts f.foobar

#puts M.methods(false)

M.methods(false).each do |meth|
	Foo.send(:define_method, meth) do
		Foo.class_exec { M.send(meth) }
	end
end

f.get_foobar
