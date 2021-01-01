require_relative 'common'

class Tile
  attr_reader :name, :number, :contents

  def initialize(name, contents)
    @name = name
    @number = name.match(/(\d+)/)[1].to_i if name.match?(/\d/)
    @contents = contents
  end

  module Positioning
    def could_add_left?(tile);   left_edge   == tile.right_edge;  end
    def could_add_right?(tile);  right_edge  == tile.left_edge;   end
    def could_add_top?(tile);    top_edge    == tile.bottom_edge; end
    def could_add_bottom?(tile); bottom_edge == tile.top_edge;    end
  end
  include Positioning

  module Edges
    def left_edge;   @contents.map(&:first).join; end
    def right_edge;  @contents.map(&:last).join;  end
    def top_edge;    @contents.first;             end
    def bottom_edge; @contents.last;              end

    def edges
      [top_edge, left_edge, bottom_edge, right_edge]
    end

    def without_edges
      stripped_contents = @contents.
        slice(1...-1). # Removing top/bottom borders
        map { |l| l[1...-1] } # Removing left/right borders
      self.class.new(name, stripped_contents)
    end
  end
  include Edges

  module Manipulations
    def all_versions
      [
        self,            self.flip_x,            self.flip_y,
        self.rotate_90,  self.flip_x.rotate_90,  self.flip_y.rotate_90,
        self.rotate_180, self.flip_x.rotate_180, self.flip_y.rotate_180,
        self.rotate_270, self.flip_x.rotate_270, self.flip_y.rotate_270,
      ].uniq
    end

    def rotate_90
      self.class.new(@name, @contents.map(&:chars).transpose.map(&:reverse).map(&:join))
    end

    def rotate_180
      self.class.new(@name, @contents.reverse.map(&:reverse))
    end

    def rotate_270
      self.class.new(@name, @contents.map(&:reverse).map(&:chars).transpose.map(&:join))
    end

    def flip_x
      self.class.new(@name, @contents.map(&:reverse))
    end

    def flip_y
      self.class.new(@name, @contents.reverse)
    end
  end
  include Manipulations
end

class Grid
  NEIGHBORS_OFFSET = [
    [-1, 0], [0, -1], [0, 1], [1, 0],
  ].freeze

  def initialize(size_x, size_y)
    @tiles = {}
    @size_x = size_x
    @size_y = size_y
  end

  def tiles
    @tiles.sort_by { |(x,y),_| [y,x] }.to_h # Line by line
  end

  def try_to_add(tile, x,y)
    left = self[x-1, y]
    right = self[x+1, y]
    top = self[x, y-1]
    bottom = self[x, y+1]

    all_neighbors_ok = [
      left.nil?   || left.could_add_right?(tile),
      right.nil?  || right.could_add_left?(tile),
      top.nil?    || top.could_add_bottom?(tile),
      bottom.nil? || bottom.could_add_top?(tile),
    ].all?

    return unless all_neighbors_ok

    @tiles[[x,y]] = tile

    true
  end

  def [](x,y)
    @tiles[[x,y]]
  end

  # /!\ Can reach out of the grid
  def neighbors_of(coords)
    NEIGHBORS_OFFSET.map do |offsets|
      offsets.zip(coords).map { |(offset, coord)| offset+coord }
    end
  end

  def free_adjacent_spaces
    board = (0...@size_x).to_a.product((0...@size_y).to_a)
    adjacent_spaces = @tiles.keys.each_with_object([]) do |pos, spaces|
      neighbors_of(pos).each { |neighbor| spaces << neighbor }
    end
    (board & adjacent_spaces) - @tiles.keys
  end

  def solve_with(tiles)
    tiles = tiles.dup
    grid = self.dup

    until tiles.empty?
      added_tile = tiles.find do |tile|
        tile.all_versions.find do |version|
          grid.free_adjacent_spaces.find do |space|
            grid.try_to_add(version, *space)
          end
        end
      end
      raise "Unsolvable grid" unless added_tile
      tiles.delete(added_tile)
    end
    grid
  end
end

class Day20 < AdventDay
  MONSTER_PATTERN = <<~MONSTER
                    #
  #    ##    ##    ###
   #  #  #  #  #  #
  MONSTER

  def main
    tiles = input.dup
    figure_out_corners(tiles).
      map { |tile, _| tile.number }.
      reduce(&:*)
  end

  def alternate
    solved_grid = solve(input.dup)
    picture = build_picture_from_grid(solved_grid)
    number_of_monsters = count_monsters(picture)
    monster_spots_count = number_of_monsters * MONSTER_PATTERN.count('#')
    picture.count('#') - monster_spots_count # Troubled waters = troubles - monsters
  end

  private

  def solve(tiles)
    size = Math.sqrt(tiles.length).to_i
    grid = Grid.new(size, size)

    (corner, edges), * = *figure_out_corners(tiles) # Find a corner
    corner = corner. # Orient it to outside the grid
      all_versions.find { |vers| ([vers.top_edge, vers.left_edge] & edges.sort).count == 2 }
    grid.try_to_add(corner, 0,0) # Add to board as starting piece

    # Solve with remaining
    remaining_tiles = tiles.reject { |t| t.number == corner.number }
    grid.solve_with(remaining_tiles)
  end

  def build_picture_from_grid(grid)
    tiles = grid.tiles.transform_values { |tile| tile.without_edges }
    max_lines = tiles.keys.map { |_x,y| y }.max
    (0..max_lines).map do |line|
      tiles.select { |(x,y),_| y == line }.to_h.values.map(&:contents).transpose.map(&:join).join("\n")
    end.join("\n")
  end

  def count_monsters(picture, pattern: MONSTER_PATTERN)
    picture_tile = Tile.new("picture", picture.split("\n"))
    pattern = MONSTER_PATTERN
    pattern_lines = pattern.split("\n")
    max_line_length = pattern_lines.map(&:length).max
    padded = pattern_lines.map { |line| line.ljust(max_line_length, ' ') }

    matcher_lines = convert_pattern_to_regexps(padded)

    picture_tile.all_versions.sum do |picture_version|
      picture_version.contents.each_cons(pattern_lines.count).sum do |lines|
        iterator_for(lines, max_line_length).count do |rows|
          rows.zip(matcher_lines).all? { |(row, matcher)| row.match? matcher }
        end
      end
    end
  end

  def iterator_for(rows, pattern_length)
    # Iterate in sync across several rows of the same length
    Enumerator.new do |yielder|
      enums = rows.map { |row| row.chars.each_cons(pattern_length) }
      loop do
        yielder << enums.map { |enum| enum.next.join }
      end
    end
  end

  def convert_pattern_to_regexps(pattern_lines)
    pattern_lines.map do |line|
      regexified_line = line.tr(' ', '.').gsub(/([^.])/, '(\1)')
      Regexp.new(regexified_line)
    end
  end

  def figure_out_edge_intersections(tiles)
    edges = tiles.map { |t| [t, t.all_versions.map(&:edges).flatten.uniq] }.to_h
    tiles.map { |tile| [tile, (edges[tile] - edges.without(tile).values.flatten)] }
  end

  def figure_out_corners(tiles)
    figure_out_edge_intersections(tiles).
      select { |_, lone_edges| lone_edges.count == 4 }. # x 2 bc of reversed matches
      to_h
  end

  def convert_data(data)
    data.split("\n\n").map do |tile|
      tile_name, *tile_content = super(tile)
      Tile.new(tile_name, tile_content)
    end
  end
end

Day20.solve
