require_relative "klass.rb"
require_relative "module.rb"
require_relative "main.rb"

main

Foo.send(:define_method, 'bar') do
	puts "I am D bar !"
end

main

Foo.send(:define_method, 'bar') do
	puts "I am M bar !"
end

main

Foo.send(:define_method, 'bar') do
	puts "I am D bar !"
end

Foo.send(:define_method, 'bar') do
	puts "I am M bar !"
end

Foo.send(:define_method, 'bar') do
	puts "I am S bar !"
end

main
