require_relative 'common'

class Day5 < AdventDay
  def main
    input.map { |seat| seat[:id] }.max
  end

  def alternate
    free_seats = (0..main).to_a - input.map { |seat| seat[:id] }
    # We know we have neighboring seats
    free_seats.find { |seat_id| !free_seats.include?(seat_id - 1) && !free_seats.include?(seat_id + 1)}
  end

  private

  def convert_data(data)
    super.map do |binary_place|
      bin_x = binary_place[..6]
      bin_y = binary_place[7..]
      x = bin_x.tr(?F, ?0).tr(?B, ?1).to_i(2)
      y = bin_y.tr(?L, ?0).tr(?R, ?1).to_i(2)
      { x: x, y: y, id: x*8+y}
    end
  end
end

p Day5.new.main
p Day5.new.alternate
