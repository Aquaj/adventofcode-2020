require_relative 'common'

class Day8 < AdventDay
  NOOP = 'nop'
  JUMP = 'jmp'
  ADDV = 'acc'

  def initialize
    reset_memory!
  end

  def main
    code = input
    loop do
      return @accumulator if @instructions_ran.include? @program_counter
      run_instruction(*code[@program_counter])
    end
  end

  # Not a fan of this bruteforcing but it runs fast enough
  def alternate
    code = input
    @flips_to_try = code.each_with_index.select{ |(op,arg),i| op == NOOP || op == JUMP }.map(&:last)
    @flips_to_try.each do |flip_to_try|
      reset_memory!
      loop do
        break if @instructions_ran.include? @program_counter # Go next flip if loop
        curr_instruction = code[@program_counter]
        curr_instruction = flip_instruction(*curr_instruction) if @program_counter == flip_to_try
        run_instruction(*curr_instruction)
        return @accumulator if @program_counter == code.length # Reached EOF == success
      end
    end
  end

  private

  def flip_instruction(op, arg)
    case op
    when NOOP
      [JUMP, arg]
    when JUMP
      [NOOP, arg]
    end
  end

  def reset_memory!
    @instructions_ran = Set.new
    @program_counter = 0
    @accumulator = 0
  end


  def run_instruction(op, arg)
    @instructions_ran << @program_counter
    case op
    when ADDV
      @accumulator += arg
    when JUMP
      return @program_counter += arg
    when NOOP # noop
    end
    @program_counter += 1
  end

  def convert_data(data)
    super.map { |instr| instr.split.then {|(op, arg)| [op, arg.to_i] } }
  end
end

p Day8.new.main
p Day8.new.alternate
