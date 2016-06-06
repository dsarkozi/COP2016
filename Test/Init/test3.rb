require_relative "klass.rb"
require_relative "module.rb"

main = IO.read "main.rb"

#puts main

eval main

eval "using D;" + main

eval "using M;" + main
