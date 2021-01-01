require_relative 'common'

require 'rltk'

class MessageParser
  class Lexer < RLTK::Lexer
    rule(/a/) { :A }
    rule(/b/) { :B }
  end

  def initialize(rules)
    @rules = rules
    @parser = self.class.parser_for(rules)
  end

  def message_valid?(message)
    tokens = Lexer.lex(message)
    @parser.parse(tokens)
  rescue RLTK::NotInLanguage
    false
  else
    true
  end

  private

  def self.parser_for(message_rules)
    Class.new(RLTK::Parser) do
      # Using array arg_types allows us not to have actions associated with the clauses
      # which is convenient since we only want to check language inclusion
      default_arg_type :array

      start :rule0

      production(:a, "A") { |*| }
      production(:b, "B") { |*| }

      message_rules.each do |prod_name, clauses|
        production(prod_name.to_sym) do
          clauses.split(' | ').each do |clause_val|
            clause(clause_val) { |*| }
          end
        end
      end

      finalize
    end
  end
end

class Day19 < AdventDay
  RULES_OVERRIDE = {
    rule8: "rule42 | rule42 rule8",
    rule11: "rule42 rule31 | rule42 rule11 rule31",
  }.freeze

  def main
    data = input.dup
    message_parser = MessageParser.new(data[:rules])
    data[:messages].count { |mess| message_parser.message_valid?(mess) }
  end

  def alternate
    data = input.dup
    message_parser = MessageParser.new(data[:rules].merge(RULES_OVERRIDE))
    data[:messages].count { |mess| message_parser.message_valid?(mess) }
  end

  private

  def convert_data(data)
    rules_input, messages_input = data.split("\n\n")

    rules_raw = super(rules_input)
    rules = rules_raw.map do |rule|
      safe_rule = rule.gsub(/(\d+)/, 'rule\1').tr('"', '')
      safe_rule.split(':').map(&:strip)
    end.to_h

    { rules: rules,  messages: super(messages_input) }
  end
end

Day19.solve
