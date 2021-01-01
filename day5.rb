require_relative 'common'

class Day5 < AdventDay
  def first_part
    highest_seat_number
  end

  def second_part
    free_seats = (0..highest_seat_number).to_a - input.map { |seat| seat[:id] }
    # We know we have neighboring seats
    free_seats.find { |seat_id| !free_seats.include?(seat_id - 1) && !free_seats.include?(seat_id + 1)}
  end

  private

  def highest_seat_number
    input.map { |seat| seat[:id] }.max
  end

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

Day5.solve
