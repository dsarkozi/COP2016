require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

f = Foo.new
f.bar
f.foo
puts f.foobar
main
puts

feature = IO.read "M.rb"
Foo.class_eval feature

main
f.bar
f.foo
f.get_foobar
puts

feature = IO.read "D.rb"
Foo.class_eval feature

main
f.bar
f.foo
f.get_foobar
puts

feature = IO.read "default.rb"
Foo.class_eval feature

main
f.bar
f.foo
f.get_foobar

puts Foo.instance_methods(false)
