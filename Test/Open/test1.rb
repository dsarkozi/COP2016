require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

main

Foo.class_eval "prepend M";

main

Foo.class_eval "prepend D";

main

Foo.class_eval "prepend M";
Foo.class_eval "prepend D";
Foo.class_eval "prepend S";

main

Foo.class_eval "prepend D";
Foo.class_eval "prepend M";

main
