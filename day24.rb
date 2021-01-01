require_relative 'common'

class Day24 < AdventDay
  E = 'E'
  W = 'W'
  SW = 'SW'
  SE = 'SE'
  NW = 'NW'
  NE = 'NE'
  NEIGHBORS = {
    E => [2, 0],
    W => [-2, 0],
    SW => [-1, -1],
    SE => [1, -1],
    NW => [-1, 1],
    NE => [1, 1],
  }.freeze

  def main
    instructions = input.dup
    setup_tiles(instructions).count
  end

  def alternate
    tiles = setup_tiles(input.dup)
    Enumerator.new do |yielder|
      loop do
        white_with_black_neighbors = {}
        new_tiles = tiles.each_with_object(Set.new) do |tile, new_tileset|
          neighbors = neighbors_of(*tile)
          neighbors.each do |neighbor|
            white_with_black_neighbors[neighbor] ||= 0
            white_with_black_neighbors[neighbor] += 1
          end

          active_neighbors = neighbors.count { |n| tiles.include?(n) }
          new_tileset << tile if [1,2].include?(active_neighbors)
        end

        white_with_black_neighbors.
          select {|_tile, neighbor_count| neighbor_count == 2 }.
          keys.
          each_with_object(new_tiles) do |tile, new_tileset|
            new_tileset << tile
          end
        yielder << new_tiles
        tiles = new_tiles
      end
    end.nth(100).count
  end

  private

  def setup_tiles(instructions)
    instructions.each_with_object(Set.new) do |path, black_tiles|
      tile_to_flip = path.reduce([0,0]) do |final_pos, move|
        x,y = *final_pos
        offset_x,offset_y = *NEIGHBORS[move]
        [x+offset_x, y+offset_y]
      end

      if black_tiles.include? tile_to_flip
        black_tiles.delete(tile_to_flip)
      else
        black_tiles << tile_to_flip
      end
    end
  end

  def neighbors_of(x,y)
    NEIGHBORS.map do |_dir, offsets|
      offset_x,offset_y = offsets
      [x+offset_x, y+offset_y]
    end
  end

  def convert_data(data)
    conversion = {
      'SW' => 'A',
      'SE' => 'B',
      'NW' => 'C',
      'NE' => 'D',
    }

    instructions = super data.upcase

    instructions.map do |path|
      conversion.each { |from, to| path.gsub!(from, to) }
      path.chars.map { |c| conversion.invert.fetch(c, c) }
    end
  end
end

Day24.solve
