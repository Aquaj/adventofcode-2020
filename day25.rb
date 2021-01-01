require_relative 'common'

class Day25 < AdventDay
  CRYPT_KEY = 20201227

  def main
    card_public_key, door_public_key = *input.dup
    _card_loop_size = break_key(card_public_key)
    door_loop_size = break_key(door_public_key)
    card_public_key.pow(door_loop_size, CRYPT_KEY)
  end

  def alternate
    'Nothing to do — 🌟🎉'
  end

  private

  def break_key(public_key, subject_number: 7)
    baby_steps_giant_steps(subject_number, public_key, CRYPT_KEY)
  end

  def baby_steps_giant_steps(a,b,p,n: nil)
    n = Math.sqrt(p).ceil unless n

    #initialize baby_steps table
    baby_steps = {}
    baby_step = 1

    (0..n).each do |r|
      baby_steps[baby_step] = r
      baby_step = (baby_step * a) % p
    end

    #now take the giant steps
    giant_stride = a.pow((p-2)*n,p)
    giant_step = b
    (0..n).each do |q|
      return q*n + baby_step if baby_step = baby_steps[giant_step]
      giant_step = (giant_step * giant_stride) % p rescue byebug
    end
    raise "No match"
  end

  def convert_data(data)
    super.map(&:to_i)
  end
end

Day25.solve
