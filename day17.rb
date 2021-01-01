require_relative 'common'

class ConwayGrid
  ACTIVE = '#'.freeze
  INACTIVE = '.'.freeze

  def self.neighbors_offsets(dimension: self::DIMENSION)
    @neighbors_offsets ||= (dimension - 1).times.reduce([-1, 0, 1]) do |agg, _n|
      agg.product([-1, 0, 1]).map { |coords, new_coord| [*coords, new_coord] }
    end - [[0] * dimension]
  end

  attr_reader :actives

  def initialize(actives = Set.new)
    @actives = actives
  end

  def add_active(*coords)
    @actives << coords
  end

  def compute_next
    inactive_with_active_neighbors = {}
    next_grid = self.class.new
    @actives.each_with_object(next_grid) do |coords, grid|
      neighbors = neighbors_of(*coords)
      neighbors.each do |neighbor|
        inactive_with_active_neighbors[neighbor] ||= 0
        inactive_with_active_neighbors[neighbor] += 1
      end

      active_neighbors = neighbors.count { |n| @actives.include?(n) }
      grid.add_active(*coords) if [2,3].include?(active_neighbors)
    end

    inactive_with_active_neighbors.
      select {|_cube, neighbor_count| neighbor_count == 3 }.
      keys.
      each_with_object(next_grid) do |coords, grid|
        grid.add_active(*coords)
      end
  end

  def neighbors_of(*coords)
    self.class.neighbors_offsets.map do |offsets|
      offsets.zip(coords).map { |(offset, coord)| offset+coord }
    end
  end

  def dimensions
    @actives.first.map.with_index do |_, index|
      min_dim = @actives.min_by { |coords| coords[index] }[index]
      max_dim = @actives.max_by { |coords| coords[index] }[index]
      [min_dim, max_dim]
    end
  end

  def get(*coords)
    return ACTIVE if @actives.include?(coords)
    INACTIVE
  end
end

class Dim3ConwayGrid < ConwayGrid
  DIMENSION = 3

  # There's probably a way to do this dynamically too
  def self.from_layers(initial_layers)
    actives = Set.new
    initial_layers.each_with_index do |layer, z|
      layer.each_with_index do |line, y|
        line.each_with_index do |status, x|
          actives << [x,y,z] if status == ACTIVE
        end
      end
    end
    new(actives)
  end

  # There's probably a way to do this dynamically too
  def inspect
    ((min_x, max_x), (min_y, max_y), (min_z, max_z)) = dimensions
    (min_z..max_z).map do |z|
      "z = #{z}" + "\n" + (min_y..max_y).map do |y|
        (min_x..max_x).map { |x| get(x,y,z) }.join
      end.join("\n")
    end.join("\n\n")
  end
end

class Dim4ConwayGrid < ConwayGrid
  DIMENSION = 4

  # There's probably a way to do this dynamically too
  def self.from_layers(initial_grid)
    actives = Set.new
    initial_grid.each_with_index do |layers, w|
      layers.each_with_index do |layer, z|
        layer.each_with_index do |line, y|
          line.each_with_index do |status, x|
            actives << [x,y,z,w] if status == ACTIVE
          end
        end
      end
    end
    new(actives)
  end

  # There's probably a way to do this dynamically too
  def inspect
    ((min_x, max_x), (min_y, max_y), (min_z, max_z), (min_w, max_w)) = dimensions
    (min_w..max_w).map do |z|
      (min_z..max_z).map do |z|
        "z = #{z}, w = #{w}" + "\n" + (min_y..max_y).map do |y|
          (min_x..max_x).map { |x| get(x,y,z) }.join
        end.join("\n")
      end.join("\n\n")
    end.join("\n\n")
  end
end

class Day17 < AdventDay
  def first_part
    grid = Dim3ConwayGrid.from_layers([input])
    Enumerator.produce(grid, &:compute_next).nth(21).actives.count
  end

  def second_part
    grid = Dim4ConwayGrid.from_layers([[input]])
    Enumerator.produce(grid, &:compute_next).nth(7).actives.count
  end

  private

  def convert_data(data)
    super.map(&:chars)
  end
end

Day17.solve
