require_relative 'condition'

# Class ConditionsTree in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  class ConditionsTree
    
    attr_accessor :leftChild, :rightChild

    def initialize(operator, condition)
      @operator = operator
      @condition = condition
      @leftChild = nil
      @rightChild = nil
    end

    def self.createConditionsTree(conditions, sensors)
      return nil if (!conditions || conditions.empty?)

      raise SyntaxError, "Wrong format for condition : #{conditions}" if !conditions.match(/^\(+.*\)+$/)
      sClone = conditions.dup
      queue = []
      checkBrackets = 0
      while(!sClone.empty?)
        conditionMatch = sClone.match(/^(\({1}[^\(\)]*\s[^\(\)]*\s[^\(\)]*\){1})/)
        if conditionMatch
          conditionString = conditionMatch[0]
          length = conditionString.length
          conditionString[0] = ''
          conditionString = conditionString.chop
          newTree = ConditionsTree.createLeaf(conditionString, sensors)
          queue << newTree
          sClone[0...length] = ''
        elsif sClone.start_with?('(')
          checkBrackets += 1
          sClone[0] = ''
        elsif sClone.start_with?(')')
          queue << linkConditionsTree(queue)
          checkBrackets -= 1
          sClone[0] = ''
        elsif sClone.start_with?(' ')
          sClone[0] = ''
        elsif sClone.match(/^[!&|]\s*\(*.*\({1}[^\(\)]*\s[^\(\)]*\s[^\(\)]*\){1}\)+/)
          operatorMatch = sClone.match(/^[!&|]/)
          newTree = ConditionsTree.createNode(operatorMatch[0])
          queue << newTree
          sClone[0] = ''
        else
          raise SyntaxError, "Wrong format for condition : #{conditions}"
        end
      end

      raise SyntaxError, "Wrong format for condition (error with brackets) : #{conditions}" if checkBrackets != 0
      raise SyntaxError, "Wrong format for condition (queue.length != 1) : #{conditions}" if queue.length != 1
      
      queue.first
    end

    def addChildren(left, right)
      @leftChild = left
      @rightChild = right
    end

    def notOperator?
      @operator && @operator == '~'.to_sym
    end

    def applyConditions(o, parentsSensors)
      isOk = true
      if @condition
        isOk = @condition.apply(o, parentsSensors)
      else
        leftChildApplied = @leftChild.applyConditions(o, parentsSensors) if @leftChild
        rightChildApplied = @rightChild.applyConditions(o, parentsSensors) if @rightChild

        isOk &= rightChildApplied.send(@operator) unless @leftChild
        isOk &= leftChildApplied.send(@operator, rightChildApplied) if @leftChild
      end
      isOk
    end

    def DFS(indent=0)
     indentString = ""
     indent.times{
       |i|
       indentString << "\t"
     }
     @leftChild.DFS(indent+1) if @leftChild
     puts "#{indentString}#{self}"
     @rightChild.DFS(indent+1) if @rightChild
    end

    def to_s
      return "@operator\t#{@operator}" if @operator
      return "@condition\t#{@condition}" if @condition
    end

    private 

    def self.createNode(operator)
      ConditionsTree.new(operator.to_sym, nil)
    end

    def self.createLeaf(conditionString, sensors)
      ConditionsTree.new(nil, Condition.new(conditionString, sensors))
    end

    def self.linkConditionsTree(q)
      if q.length >= 2
        if q[-2].notOperator?
          rightChild = q.pop
          operator = q.pop
          operator.addChildren(nil, rightChild)
          return operator
        else
          rightChild = q.pop
          operator = q.pop
          leftChild = q.pop
          operator.addChildren(leftChild, rightChild)
          return operator
        end 
      end
    end

  end

end