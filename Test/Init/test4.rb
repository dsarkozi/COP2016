require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

main

eval "class Foo; def bar; puts 'I am D bar !'; end; end; main"

eval "class Foo; def bar; puts 'I am M bar !'; end; end; main"
