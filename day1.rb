require_relative 'common'

class Day1 < AdventDay
  def first_part
    pair = input.combination(2).find { |a,b| a+b == 2020 }
    pair.reduce(&:*)
  end

  def second_part
    triplet = input.combination(3).find { |a,b,c| a+b+c == 2020 }
    triplet.reduce(&:*)
  end

  def convert_data(data)
    super.map(&:to_i)
  end
end

Day1.solve
