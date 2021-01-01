require 'bundler'
require 'dotenv/load'

Bundler.require

require 'benchmark'
require 'net/http'

class AdventDay
  SESSION = ENV['SESSION'] || ''

  def self.solve
    puts " - #{(Benchmark.measure { print self.new.main.inspect }.real * 1000).round(3)}ms"
    puts " - #{(Benchmark.measure { print self.new.alternate.inspect }.real * 1000).round(3)}ms"
  end

  def main; end
  def alternate; end

  def convert_data(data)
    data.split("\n")
  end

  def input
    input_path = Pathname.new('inputs/'+day_number)
    input_data = if input_path.exist?
      File.read(input_path)
    else
      download_input
    end
    convert_data(input_data)
  end

  INPUT_BASE_URL = 'https://adventofcode.com'.freeze
  INPUT_PATH_SCHEME = '/%{year}/day/%{number}/input'.freeze

  def download_input
    res = Faraday.get(
      INPUT_BASE_URL + INPUT_PATH_SCHEME % { year: 2020, number: day_number },
      nil,
      { 'Cookie' => "session=#{SESSION}" },
    )
    File.write('inputs/'+day_number, res.body)
    res.body
  end

  def day_number
    @day_number ||= self.class.name.gsub('Day', '')
  end
end
