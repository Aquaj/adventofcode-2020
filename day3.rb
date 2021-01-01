require_relative 'common'

class Day3 < AdventDay
  TREE = '#'
  TRAJECTORIES = [
    { x: 1, y: 1 }.freeze,
    { x: 3, y: 1 }.freeze,
    { x: 5, y: 1 }.freeze,
    { x: 7, y: 1 }.freeze,
    { x: 1, y: 2 }.freeze,
  ].freeze
  MAIN_TRAJECTORY = TRAJECTORIES[1]

  def main
    collisions_for(MAIN_TRAJECTORY)
  end

  def alternate
    TRAJECTORIES.map { |trajectory| collisions_for(trajectory) }.reduce(:*)
  end

  private

  def collisions_for(trajectory)
    tree_rows = input.dup
    position_x = 0 # starting column
    tree_rows.every(trajectory[:y]).drop(1).lazy.map do |row|
      position_x = (position_x + trajectory[:x]) % row.length
      row[position_x]
    end.count(TREE)
  end
end

p Day3.new.main
p Day3.new.alternate
