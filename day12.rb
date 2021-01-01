require_relative 'common'

module Positionable
  NORTH = 'N'
  SOUTH = 'S'
  EAST = 'E'
  WEST = 'W'
  CARDINAL_ORDER = [NORTH, EAST, SOUTH, WEST]

  #   N     ^y
  #   ^     |
  # <   >   |
  #   v     +----> x

  def manhattan_distance
    @x.abs + @y.abs
  end

  def move_north(units)
    @y += units
  end

  def move_south(units)
    @y -= units
  end

  def move_east(units)
    @x += units
  end

  def move_west(units)
    @x -= units
  end

  def rotate_left(degrees)
    adjustment = case degrees
    when 90 then -1
    when 180 then -2
    when 270 then -3
    end
    cardinal_index = CARDINAL_ORDER.index(@orientation)
    @orientation = CARDINAL_ORDER[(cardinal_index + adjustment) % CARDINAL_ORDER.length]
  end

  def rotate_right(degrees)
    adjustment = case degrees
    when 90 then 1
    when 180 then 2
    when 270 then 3
    end
    cardinal_index = CARDINAL_ORDER.index(@orientation)
    @orientation = CARDINAL_ORDER[(cardinal_index + adjustment) % CARDINAL_ORDER.length]
  end

  def move_forward(units)
    case @orientation
    when NORTH then move_north(units)
    when SOUTH then move_south(units)
    when EAST then move_east(units)
    when WEST then move_west(units)
    end
  end
end

class BasicShip
  include Positionable

  def initialize
    @x = 0
    @y = 0
    @orientation = Positionable::EAST
  end
end

class Waypoint
 include Positionable

  attr_reader :x, :y

  def initialize
    @x = 10
    @y = 1
    @orientation = Positionable::EAST
  end

  def rotate_left(degrees)
    rot_matrix = case degrees
    when 90 then [[0, -1],[1, 0]]
    when 180 then [[-1, 0],[0, -1]]
    when 270 then [[0, 1],[-1, 0]]
    end
    old_x, old_y = @x, @y
    @x = old_x * rot_matrix[0][0] + old_y * rot_matrix[0][1]
    @y = old_x * rot_matrix[1][0] + old_y * rot_matrix[1][1]
  end

  def rotate_right(degrees)
    rot_matrix = case degrees
    when 90 then [[0, 1],[-1, 0]]
    when 180 then [[-1, 0],[0, -1]]
    when 270 then [[0, -1],[1, 0]]
    end
    old_x, old_y = @x, @y
    @x = old_x * rot_matrix[0][0] + old_y * rot_matrix[0][1]
    @y = old_x * rot_matrix[1][0] + old_y * rot_matrix[1][1]
  end
end

class GuidedShip < BasicShip
  include Positionable

  attr_reader :waypoint

  def initialize
    super
    @waypoint = Waypoint.new
  end

  def move_forward(units)
    @x += waypoint.x * units
    @y += waypoint.y * units
  end
end

class Day12 < AdventDay
  NORTH = 'N'
  SOUTH = 'S'
  EAST = 'E'
  WEST = 'W'
  RIGHT = 'R'
  LEFT = 'L'
  FORWARD = 'F'

  def main
    @ship = BasicShip.new
    instructions = input.dup
    instructions.each do |instruction, arg|
      case instruction
      when NORTH then @ship.move_north arg
      when SOUTH then @ship.move_south arg
      when EAST then @ship.move_east arg
      when WEST then @ship.move_west arg
      when RIGHT then @ship.rotate_right arg
      when LEFT then @ship.rotate_left arg
      when FORWARD then @ship.move_forward arg
      end
    end
    @ship.manhattan_distance
  end

  def alternate
    @ship = GuidedShip.new
    instructions = input.dup
    instructions.each do |instruction, arg|
      case instruction
      when NORTH then @ship.waypoint.move_north arg
      when SOUTH then @ship.waypoint.move_south arg
      when EAST then @ship.waypoint.move_east arg
      when WEST then @ship.waypoint.move_west arg
      when RIGHT then @ship.waypoint.rotate_right arg
      when LEFT then @ship.waypoint.rotate_left arg
      when FORWARD then @ship.move_forward arg
      end
    end
    @ship.manhattan_distance
  end

  private

  def convert_data(data)
    super.map { |instr| instr.scan(/(\w)(\d+)/).first.then { |(inst, arg)| [inst, arg.to_i] } }
  end
end

Day12.solve
