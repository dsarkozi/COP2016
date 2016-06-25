require_relative "klass.rb"
require_relative "refine.rb"
require_relative "main.rb"

main

Foo.class_exec {"using M;"}

main
