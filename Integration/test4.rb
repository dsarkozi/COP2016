require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

f = Foo.new
f.bar
main

Foo.send(:define_method, :bar) do
	M.bar
end

main
f.bar

Foo.send(:define_method, :bar) do
	D.bar
end

main
f.bar

Foo.send(:define_method, :bar) do
	M.bar
end

Foo.send(:define_method, :bar) do
	D.bar
end

Foo.send(:define_method, :bar) do
	S.bar
end

main
f.bar
