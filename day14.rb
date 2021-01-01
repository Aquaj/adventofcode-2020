require_relative 'common'

class MemoryAccessor
  EMPTY_MASK = 'X'

  attr_reader :memory
  attr_writer :mask

  def initialize
    @mask = nil
    @memory = Hash.new(0)
  end

  private

  def apply_mask(binary_val)
    return binary_val unless @mask
    # reversing it all so we don't have to pad
    to_mask = binary_val.chars.reverse
    @mask.chars.reverse.map.with_index do |mask_bit, pos|
      next yield(to_mask[pos], mask_bit)
    end.join.reverse
  end
end

class MemoryValMasker < MemoryAccessor
  def set_memory(pos, val)
    binary_val = val.to_i.to_s(2)
    masked_val = apply_mask(binary_val) do |val, mask|
      next val || 0 if mask == EMPTY_MASK
      mask
    end
    @memory[pos] = masked_val.to_i(2)
  end
end

class MemoryAdressDecoder < MemoryAccessor
  def set_memory(pos, val)
    binary_val = pos.to_i.to_s(2)
    masked_val = apply_mask(binary_val) do |val, mask|
      next mask if mask == EMPTY_MASK || mask == '1'
      val || 0
    end
    floating_bit_indices = masked_val.chars.each_index.select { |i| masked_val[i] == EMPTY_MASK }
    positions = floating_bit_indices.reduce([masked_val]) do |possible_vals, float_index|
      possible_vals.flat_map do |val|
        [0,1].map do |val_of_bit|
          new_val = val.chars
          new_val[float_index] = val_of_bit
          new_val.join
        end
      end
    end
    positions.each do |pos_to_set|
      @memory[pos_to_set.to_i(2)] = val.to_i
    end
  end
end

class Day14 < AdventDay
  MEMSET = /mem\[(\d+)\]/
  MASK = /mask/

  def main
    @memory_accessor = MemoryValMasker.new
    instructions = input.dup
    instructions.each do |op, arg|
      run_instruction(op, arg)
    end
    @memory_accessor.memory.values.sum
  end

  def alternate
    @memory_accessor = MemoryAdressDecoder.new
    instructions = input.dup
    instructions.each do |op, arg|
      run_instruction(op, arg)
    end
    @memory_accessor.memory.values.sum
  end

  private

  def run_instruction(op, arg)
    case op
    when MASK
      @memory_accessor.mask = arg
    when MEMSET
      index = op.match(MEMSET)[1]
      @memory_accessor.set_memory(index, arg)
    end
  end

  def convert_data(data)
    data = super.map { |l| l.split(' = ') }
  end
end

Day14.solve
