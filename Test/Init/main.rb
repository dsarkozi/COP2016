require "./klass.rb"

def main
	f = Foo.new
	f.bar
	puts Foo.ancestors
end
