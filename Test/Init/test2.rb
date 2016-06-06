require_relative "klass.rb"
require_relative "module.rb"


f = Foo.new

eval "f.bar"

eval "using D; f.bar"

eval "using M; f.bar"

f.bar
