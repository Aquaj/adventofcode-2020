require_relative 'common'

class Day9 < AdventDay
  CIPHER_SIZE = 25

  def main
    xmas_stream.find do |(current_cipher, next_value)|
      current_cipher.combination(2).none? { |(a,b)| a+b == next_value }
    end.last
  end

  def alternate
    current_stream, weakness = xmas_stream(full: true).find do |(current_cipher, next_value)|
      truncated_cipher = current_cipher[-CIPHER_SIZE...]
      truncated_cipher.combination(2).none? { |(a,b)| a+b == next_value }
    end
    current_stream.each_index do |i|
      (current_stream.length - i).times do |n|
        contiguous_vals = current_stream[i, n]
        contiguous_sum = contiguous_vals.sum
        break if contiguous_sum > weakness
        return contiguous_vals.then { |v| v.min + v.max } if contiguous_sum == weakness
      end
    end
  end

  private

  # Finding the right way to build the stream was a pain
  def xmas_stream(full: false)
    source = input.dup
    Enumerator.new do |yielder|
      (source.length - CIPHER_SIZE).times do |pos|
        cipher_to_yield = full ? source[0...pos+CIPHER_SIZE] : source[pos, CIPHER_SIZE]
        yielder << [cipher_to_yield, source[pos + CIPHER_SIZE]]
      end
    end
  end

  def convert_data(data)
    super.map(&:to_i)
  end
end

p Day9.new.main
p Day9.new.alternate
