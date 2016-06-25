require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

main
f = Foo.new
f.bar
f.foo

#puts M.methods(false)

M.methods(false).each do |meth|
	Foo.send(:define_method, meth) do
		Foo.class_exec { M.send(meth) }
	end
end

main
f.bar
f.foo
