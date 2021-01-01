require_relative 'common'

class Lounge
  EMPTY_SEAT = 'L'
  OCCUPIED_SEAT = '#'
  FLOOR = '.'

  def initialize(lines)
    @lines = lines
    @width = lines.first.length
    @height = lines.length
  end

  def inspect
    puts @lines
  end

  def next
    self.class.new @height.times.map { |y|
      @width.times.map do |x|
        current_state = @lines[y][x]
        next FLOOR if current_state == FLOOR

        occupied_count = neighbors_of(x, y).count(OCCUPIED_SEAT)

        case
        when occupied_count == 0 then OCCUPIED_SEAT
        when occupied_count >= self.class::MAX_SEAT_TOLERANCE then EMPTY_SEAT
        else current_state
        end
      end.join
    }
  end

  def seats
    @lines.join.tr(FLOOR, '').chars
  end

  def ==(oth)
    @lines == oth.lines
  end

  protected

  attr_reader :lines
end

class NaiveLounge < Lounge
  MAX_SEAT_TOLERANCE = 4

  def neighbors_of(x,y)
    neighbors = [x+1, x, x-1].product([y-1, y, y+1]) - [[x, y]]
    neighbors.lazy.
      reject { |(xn,yn)| !(0...@width).include?(xn) || !(0...@height).include?(yn) }.
      map { |(xn, yn)| @lines[yn][xn] }
  end
end

class LoungeWithSight < Lounge
  MAX_SEAT_TOLERANCE = 5

  def neighbors_of(x,y)
    directions = [-1, 0, 1].product([-1, 0, 1]) - [[0, 0]]
    directions.map { |dir| visible_neighbor_of(x,y, dir) }.compact
  end

  def visible_neighbor_of(x,y, direction)
    dx,dy = direction
    xn = x+dx
    yn = y+dy
    return unless (0...@width).include?(xn) && (0...@height).include?(yn)
    value = @lines[yn][xn]
    return visible_neighbor_of(xn,yn, direction) if value == FLOOR
    value
  end
end

class Day11 < AdventDay
  def main
    lounge = NaiveLounge.new(input)
    loop do
      prev = lounge
      lounge = lounge.next
      break lounge if prev == lounge
    end
    lounge.seats.count(Lounge::OCCUPIED_SEAT)
  end

  def alternate
    lounge = LoungeWithSight.new(input)
    loop do
      prev = lounge
      lounge = lounge.next
      break lounge if prev == lounge
    end
    lounge.seats.count(Lounge::OCCUPIED_SEAT)
  end
end

Day11.solve
