require_relative 'common'

class Day2 < AdventDay
  def first_part
    input.count do |policy_min, policy_max, policy_char, password|
      count = password.chars.count(policy_char)
      count >= policy_min && count <= policy_max
    end
  end

  def second_part
    input.count do |policy_index_a, policy_index_b, policy_char, password|
      [password[policy_index_a-1], password[policy_index_b-1]].count(policy_char) == 1
    end
  end

  private

  def convert_data(data)
    # OPT: Use a regexp with 4 match groups to extract instead of splits
    super.lazy.map { |e| e.split(': ') }.map do |policy, password|
      policy_range, policy_char = policy.split(' ')
      policy_a, policy_b = policy_range.split('-')
      [policy_a.to_i, policy_b.to_i, policy_char, password]
    end
  end
end

Day2.solve
