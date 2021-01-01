require_relative 'common'

class Day4 < AdventDay
  module Validations
    def validate_byr(year); year.match?(/^\d{4}$/) && (1920..2002).include?(year.to_i); end
    def validate_iyr(year); year.match?(/^\d{4}$/) && (2010..2020).include?(year.to_i); end
    def validate_eyr(year); year.match?(/^\d{4}$/) && (2020..2030).include?(year.to_i); end
    def validate_hgt(height)
      case height.scan(/^\d+(in|cm)$/).first&.first
      when 'in' then (59..76).include? height.to_i
      when 'cm' then (150..193).include? height.to_i
      else false
      end
    end
    def validate_hcl(color); color.match?(/^#[0-9a-f]{6}$/); end
    def validate_ecl(color); %w[amb blu brn gry grn hzl oth].include?(color); end
    def validate_pid(pid); pid.match?(/^\d{9}$/); end
    def validate_cid(cid); true; end
  end
  include Validations

  VALID_PROPERTIES = %w[
    byr iyr eyr hgt
    hcl ecl pid cid
  ].freeze
  OPTIONAL_PROPERTIES = %w[
    cid
  ].freeze

  def first_part
    passports = input.dup
    passports.count { |passport| VALID_PROPERTIES - passport.keys - OPTIONAL_PROPERTIES == [] }
  end

  def second_part
    passports = input.dup
    passports.count { |passport| passport_is_valid?(passport) }
  end

  private

  def passport_is_valid?(passport)
    (passport.keys - OPTIONAL_PROPERTIES).sort == (VALID_PROPERTIES - OPTIONAL_PROPERTIES).sort &&
      passport.map { |key, value| send(:"validate_#{key}", value) }.reduce(:&)
  end

  def convert_data(data)
    data.split(/\n\s*\n/). # Separate passports
      map do |passport_data|
        passport_data.
          split(/\s/). # Separate props
          map { |property| property.split(':') }. # Separate prop name and value
          to_h
      end
  end
end

Day4.solve
