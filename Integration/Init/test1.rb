require_relative "klass.rb"
require_relative "module.rb"


f = Foo.new

f.bar

using D
using M
using D

f.bar
Foo.new.bar
