require_relative '../Application/condition_tree'

# File to test the creation of conditionsTree
#
# authors Duhoux Benoît
# version 2016

tests = [
    '(A.a > 25)',
    '(!(A.a < 26))',
    '((A.a <= 25) & (A.a >= 15))', 
    '(((B.b >= 51.5) | (B.b <= 49.5)) & ((C.c >= 6.4) | (C.c <= 2.55)))', 
    '(((B.b >= 51.5) | (B.b <= 49.5)) & (C.c >= 6.4))',
    '((C.c >= 6.4) & ((B.b >= 51.5) | (B.b <= 49.5)))',
    '((A.a <= 25) & (!(A.a >= 15)))',
    '(((B.b >= 51.5) | (B.b <= 49.5)) & ((!(C.c >= 6.4)) | (C.c <= 2.55)))',
    '(A.a > 25)))',
    '(!(A.a < 26)!)',
    '(((B.b >= 51.5) | (B.b <= 49.5) & ((C.c >= 6.4) | (C.c <= 2.55)))', 
    '(!(A.a < 26)!())',
    '((C.c >= 6.4) | (B.b >= 51.5) | (B.b <= 49.5))',
    '((A.a <= 25) & !(A.a >= 15))',
    '(D.d > 25)',
]

sensors = ['A', 'B', 'C']

tests.each {
	|test|
	begin
		conditionsTree = Application::ConditionsTree.createConditionsTree(test, sensors)
		puts "PASSED -> #{test}"
		conditionsTree.DFS
	rescue SyntaxError => e
		puts "FAIL -> #{e}"
	end
}