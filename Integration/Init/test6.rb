require_relative "klass.rb"
require_relative "functions.rb"
require_relative "main.rb"

main

Foo.class_eval "prepend M";

main

Foo.class_eval "prepend D";

main
