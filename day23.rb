require_relative 'common'

# Inspired by RubyGems's Gem::List [implem](https://github.com/rubygems/rubygems/blob/master/lib/rubygems/util/list.rb)
class CupCircle
  include Enumerable

  attr_accessor :tail
  attr_reader :value, :tail, :length, :last, :links

  def initialize(value, tail = nil)
    @value = value
    @tail = tail
    if tail
      @length = tail.length + 1
      @last = tail.last
      @links = tail.links.tap { |l| l[value] = self }
    else
      @length = 1
      @last = self
      @links = { value => self }
    end
  end

  def each
    n = self
    while n
      yield n.value
      n = n.tail
    end
  end

  def prepend(value)
    raise "Already finalized" if @finalized
    self.class.new value, self
  end

  # Needed because we're a circle
  def finalize!
    @finalized = true
    propagate_final_length
    @last.tail = self
  end

  protected

  def propagate_final_length
    curr = tail
    until curr.nil?
      curr.length = self.length
      curr = curr.tail
    end
  end

  attr_writer :length
end

class Day23 < AdventDay
  def main
    cups = input
    cups.finalize!

    end_result = play_game(game_for(cups, number_of_rounds: 100))
    circle_start = end_result.links[1]
    circle_start.tail.take(cups.length - 1).join
  end

  def alternate
    initial_cups = input

    missing = reverse((initial_cups.length+1)..1_000_000)
    cups = missing.reduce(initial_cups) { |linked_list, cup| linked_list.prepend(cup) }
    cups.finalize!

    end_result = play_game(game_for(cups, initial_cup: initial_cups, number_of_rounds: 10_000_000))

    start = end_result.links[1]
    first_cup = start.tail
    second_cup = first_cup.tail
    first_cup.value * second_cup.value
  end

  private

  def play_game(game)
    game_result = nil
    loop do
      game_result = game.next
    rescue StopIteration
      break
    end
    game_result
  end

  def game_for(cups, initial_cup: cups, number_of_rounds: 100)
    selected = initial_cup
    max_val = cups.length
    # Assumption: no gaps in cup numerotation
    # Assumption: each cup number is distinct
    Enumerator.new(number_of_rounds) do |yielder|
      number_of_rounds.times do |n|
        picked_ups = 3.times.each_with_object([]) do |_, picked_cups|
          previous = (picked_cups.last || selected)
          picked_cups << previous.tail
        end

        order = [
          reverse(1...selected.value),
          reverse(selected.value+1..max_val)
        ].lazy.flat_map(&:lazy)
        picked_up_values = picked_ups.map(&:value)
        destination_value = order.find { |to_select| !picked_up_values.include? to_select }

        destination = cups.links[destination_value]

        selected.tail = picked_ups.last.tail

        following = destination.tail
        destination.tail = picked_ups.first
        picked_ups.last.tail = following

        yielder << cups
        selected = selected.tail
      end
    end
  end

  def reverse(range)
    start = range.begin
    finish = range.end
    offset = range.exclude_end? ? 1 : 0
    (finish-offset .. start).step(-1)
  end

  def convert_data(data)
    cups = data.strip.chars.map(&:to_i)
    first_val = cups.last

    cups[0...-1].
      reverse.
      reduce(CupCircle.new(first_val)) { |circle, cup| circle.prepend(cup) }
  end
end

require "benchmark"

Day23.solve
