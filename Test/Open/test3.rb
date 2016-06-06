require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

#puts Foo.ancestors

class Foo2 < Foo
end

f = Foo2.new
f.bar

Foo2.class_eval "prepend M;"

f.bar

Class.new(Foo).new.bar
