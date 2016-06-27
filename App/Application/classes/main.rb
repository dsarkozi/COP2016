require_relative 'klass'

class Main

  def run
    f = Foo.new
    loop do
      f.bar
    end
  end

end
