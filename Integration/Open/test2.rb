require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

#puts Foo.ancestors

f = Foo.new
f.bar

#main

Foo.class_eval "prepend M;"

f.bar
#main

M.send(:remove_method, :bar)

f.bar
#main

Foo.class_eval "prepend M;"

f.bar
