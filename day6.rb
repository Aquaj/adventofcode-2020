require_relative 'common'

class Day6 < AdventDay
  def first_part
    input.map { |group| group.join.chars.uniq.length }.reduce(&:+)
  end

  def second_part
    input.map do |group|
      members_count = group.length
      group.join.chars.tally.count { |_question, answers_count| answers_count == members_count }
    end.reduce(&:+)
  end

  private

  def convert_data(data)
    data.split(/\n\s*\n/).map { |group| group.split("\n") }
  end
end

Day6.solve
