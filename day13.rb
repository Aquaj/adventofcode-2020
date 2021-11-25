require_relative 'common'

class Day13 < AdventDay
  def first_part
    arrival_time, bus_frequencies = input

    bus_frequencies.compact.map do |freq|
      wait_time = freq - (arrival_time % freq)
      [freq, wait_time]
    end.min_by(&:last).reduce(&:*)
  end

  # sync(period[k] + offset[k]) === sync(offset[k] + period[k]) === LCM with -offset
  def second_part
    _arrival_time, bus_ids = input
    bus_ids.each_with_index.reduce do |(common_frequency, common_offset), (frequency, offset)|
      next [frequency, offset] if common_frequency.nil?
      next [common_frequency, common_offset] if frequency.nil?

      # -offset bc we want them to depart one AFTER the other and not before — offset 0 is first to leave
      first_common(common_frequency, common_offset, frequency, -offset)
    end.last
  end

  private

  # Inspired from https://math.stackexchange.com/a/3864593
  # Returns [common_frequency (how long until between syncs), common_offset (timestamp of first sync occurrence)]
  def first_common(a_frequency, a_offset, b_frequency, b_offset)
    gcd, s, _t = extended_gcd(a_frequency, b_frequency)
    offset_difference = a_offset - b_offset
    z = offset_difference / gcd

    # Can't happen with well-formed input - no solution
    raise ArgumentError, "Rotation reference points never synchronize." if offset_difference % gcd != 0

    common_frequency = a_frequency * b_frequency / gcd
    common_offset = (a_offset - s * z * a_frequency) % common_frequency
    return common_frequency, common_offset
  end

  # See [Extended Euclidian Algorith](https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Pseudocode)
  def extended_gcd(a,b)
    old_r, r = a, b
    old_s, s = 1, 0
    old_t, t = 0, 1

    while (r != 0)
      quotient = old_r / r
      remainder = old_r % r
      old_r, r = r, remainder
      old_s, s = s, old_s - quotient * s
      old_t, t = t, old_t - quotient * t
    end

    [old_r, old_s, old_t]
  end

  def convert_data(data)
    data = super
    arrival_time = data[0].to_i
    bus_ids = data[1].split(',').map { |id| id == 'x' ? nil : id.to_i }
    [arrival_time, bus_ids]
  end
end

Day13.solve
