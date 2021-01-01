require_relative 'common'

class Day10 < AdventDay
  ALLOWED_INTERVAL = 3

  def main
    adapters = (input + [0]).sort
    adapters.
      each_cons(2).
      map { |(a,b)| b - a }.
      tally.
      then { |counts| counts[1] * (counts[3] + 1) } # Not in input: the device power adapter that's always +3 of the max
  end

  # That one was hard to crack without trying to bruteforce it.
  def alternate
    adapters = input.sort

    source = 0
    final = adapters.max + ALLOWED_INTERVAL
    chain = [source, *adapters, final]

    contiguous_chains = chain.each_with_object([[]]) do |power, contiguities|
      if contiguities.last.last.then { |leaf| leaf.nil? || leaf > power - ALLOWED_INTERVAL }
        contiguities.last << power
      else
        contiguities << [power]
      end
    end
    contiguous_chains.map { |contiguity| path_count(contiguity.length) }.reduce(&:*)
  end

  private

  def path_count(tree_size)
    return 1 if tree_size == 1
    return 1 if tree_size == 2
    return 2 if tree_size == 3
    ALLOWED_INTERVAL * (tree_size - ALLOWED_INTERVAL) + 1
  end

  def convert_data(data)
    super.map(&:to_i)
  end
end

Day10.solve
