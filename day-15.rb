require_relative 'common'

class Day15 < AdventDay
  def first_part
    numbers = input.dup
    naive_enumerator(numbers).take(2020).last
  end

  def second_part
    numbers = input.dup
    efficient_enumerator(numbers).nth(30_000_000)
  end

  private

  def naive_enumerator(numbers)
    Enumerator.new do |yielder|
      numbers.each { |n| yielder << n }
      loop do
        curr = numbers.last
        prev = numbers[...-1].reverse.index(curr)
        new_val = (prev && prev + 1) || 0
        yielder << new_val
        numbers << new_val
      end
    end
  end

  # Store last index in Hash to save on access time (o(1) vs o(N))
  def efficient_enumerator(numbers)
    # Compute occurrnces for starting_numbers
    last_occurrence = numbers[...-1].map { |n| [n, numbers.index(n) + 1] }.to_h
    Enumerator.new do |yielder|
      numbers.each { |n| yielder << n }

      # Initialization of the loop variables
      curr_turn = numbers.length
      curr = numbers.last
      loop do
        last_turn = last_occurrence[curr]
        new_val = last_turn ? (curr_turn - last_turn) : 0

        last_occurrence[curr] = curr_turn

        yielder << new_val
        curr = new_val
        curr_turn += 1
      end
    end
  end

  def convert_data(data)
    data.split(',').map(&:to_i)
  end
end

Day15.solve
