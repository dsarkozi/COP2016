require_relative '../Utils/hash'

# File to test the framework in certains cases
#
# authors Duhoux Benoît and Sarkozi David
# version 2016

hash = {}
puts "#{hash}"

hash += {'alpha'=>['a', 'c'], 'numbers'=>[1]}
puts "#{hash}"

hash += {'alpha'=>['a', 'b'], 'special'=>['?']}
puts "#{hash}"

hash += {'numbers'=>[2, 3], 'special'=>[]}
puts "#{hash}"