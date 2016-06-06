require_relative '../Application/parser'
require_relative '../Application/context_definition'
require_relative '../Application/feature_definition_mockup'

# File to test the ContextDefinition and the FeatureDefinition
#
# authors Duhoux Benoît
# version 2016

begin
	Application::Parser.parseContextDeclarations("AppTestExecution")
	puts "**********************", 'DFS'
    Application::ContextDefinition.instance.DFS
rescue SyntaxError => e
	puts "FAIL due to SyntaxError -> #{e}"
end

begin
	Application::Parser.parseFeatureDeclarations("AppTestExecution")
	puts "**********************", 'DFS'
    Application::FeatureDefinition.instance.DFS
rescue SyntaxError => e
	puts "FAIL due to SyntaxError -> #{e}"
end