require_relative 'common'

class Day21 < AdventDay
  def main
    list = input.dup
    all_ingredients = Set.new(list.keys.flatten).freeze

    risks = allergen_risks_from(list)
    allergens = risks.values.reduce(&:union)

    non_allergens = all_ingredients - allergens
    non_allergens.sum { |non_allergen| list.sum { |ingredients,_| ingredients.count(non_allergen) } }
  end

  def alternate
    list = input.dup
    risks = allergen_risks_from(list)
    until risks.all? { |_, ingredients| ingredients.length == 1 }
      sure_things = risks.select { |_, choices| choices.length == 1 }.map { |_, choices| choices.unwrap }
      unsure_allergens = risks.select { |_, choices| choices.length > 1 }
      to_collapse = sure_things.
        find { |sure_thing| unsure_allergens.any? { |_, choices| choices.include?(sure_thing) } }

      raise "Not solvable" unless to_collapse
      unsure_allergens.each { |_, choices| choices.delete(to_collapse) }
    end
    risks.sort.map { |_allergen, ingredient_in_set| ingredient_in_set.unwrap }.join(',')
  end

  private

  def allergen_risks_from(list)
    risks = {}
    all_ingredients = Set.new(list.keys.flatten).freeze
    list.each do |ingredients, allergens|
      allergens.each do |allergen|
        risks[allergen] ||= all_ingredients.dup
        risks[allergen] &= ingredients
      end
    end
    list.to_a.combination(2).each do |(ingredients_a, allergens_a), (ingredients_b, allergens_b)|
      common_allergens = allergens_a & allergens_b
      common_ingredients = ingredients_a & ingredients_b

      common_allergens.each do |allergen|
        risks[allergen] &= common_ingredients
      end
    end
    risks
  end

  def convert_data(data)
    super.
      map { |l| l.scan(/^(.*)\(contains (.*)\)$/).flatten }.
      map{|(ingredients, allergens)| [ingredients.split(/,? /), allergens&.split(/,? /)] }.
      to_h
  end
end

Day21.solve
