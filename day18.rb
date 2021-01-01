require_relative 'common'

require 'rltk'

class Calculator
  class Lexer < RLTK::Lexer
    rule(/\+/) { :PLS }
    rule(/-/)  { :SUB }
    rule(/\*/) { :MUL }
    rule(/\//) { :DIV }

    rule(/\(/) { :LPAREN }
    rule(/\)/) { :RPAREN }

    rule(/[0-9]+/) { |t| [:NUM, t.to_i] }

    rule(/\s/)
  end

  class Parser < RLTK::Parser
    def self.grammar
      production(:exp) do
        clause('NUM') { |n| n }

        clause('LPAREN exp RPAREN') { |_, e, _| e }

        # binary
        clause('exp PLS exp') { |e0, _, e1| e0 + e1 }
        clause('exp SUB exp') { |e0, _, e1| e0 - e1 }
        clause('exp MUL exp') { |e0, _, e1| e0 * e1 }
        clause('exp DIV exp') { |e0, _, e1| e0 / e1 }
      end
      finalize
    end
  end

  class RegularMathParser < Parser
    left :PLS, :SUB, :MUL, :DIV
    grammar
  end

  class AdvancedMathParser < Parser
    left :MUL, :DIV
    left :PLS, :SUB
    grammar
  end

  def initialize(mode: :regular)
    @lexer = Lexer.new
    case mode
    when :regular
      @parser = RegularMathParser.new
    when :advanced
      @parser = AdvancedMathParser.new
    else
      raise ArgumentError, "unknown mode"
    end
  end

  def compute(expression)
    tokens = @lexer.lex(expression)
    @parser.parse(tokens)
  end
end

class Day18 < AdventDay
  def main
    @calculator = Calculator.new
    exprs = input
    exprs.map { |exp| @calculator.compute(exp) }.sum
  end

  def alternate
    @calculator = Calculator.new(mode: :advanced)
    exprs = input
    exprs.map { |exp| @calculator.compute(exp) }.sum
  end
end

Day18.solve
