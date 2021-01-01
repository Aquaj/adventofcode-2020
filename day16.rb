require_relative 'common'

class Day16 < AdventDay
  def main
    set_instance_vars_from(input)

    @other_tickets.sum { |ticket_vals| ticket_vals.select { |val| matches_any_rule?(val) }.sum }
  end

  def alternate
    set_instance_vars_from(input)

    valid_tickets = @other_tickets.reject { |ticket_vals| ticket_vals.any? { |val| matches_any_rule?(val) } }

    field_order = field_positions_for(valid_tickets)

    departure_field_pos = @fields.grep(/^departure/).map { |field| field_order[field] }
    departure_field_pos.map { |pos| @own_ticket[pos] }.reduce(&:*)
  end

  private

  def matches_any_rule?(value)
    @rules.none? { |_field, rule| matches_rule?(rule, value) }
  end

  def matches_rule?(rule, value)
    rule.any? { |allowed_range| allowed_range.include? value }
  end

  def field_positions_for(tickets)
    @rules.
      # Compute possibilities
      transform_values do |rule|
        tickets.reduce((0...@fields.length)) do |possible_positions, ticket|
          possible_positions.select { |pos| matches_rule?(rule, ticket[pos]) }
        end
      end.
      # Collapse according to constraints
      sort_by { |_field, possible_positions| possible_positions.length }.
      each_with_object({}) do |(field, available_positions), positions|
        remaining_available = available_positions - positions.values
        positions[field] = remaining_available.first
      end
  end

  def convert_data(data)
    formatted_data = {}

    rules, own_ticket, other_tickets = data.split("\n\n")

    formatted_data[:rules] = rules.split("\n").map do |rule|
      name, conditions = rule.split(': ')
      [name, conditions.split(' or ').map { |range| start, finish = range.split('-'); (start.to_i..finish.to_i) }]
    end.to_h

    own_ticket = own_ticket.split("\n").last
    formatted_data[:own_ticket] = own_ticket.split(",").map(&:to_i)
    other_tickets = other_tickets.split("\n")[1...]
    formatted_data[:other_tickets] = other_tickets.map { |ticket| ticket.split(",").map(&:to_i) }

    formatted_data
  end

  def set_instance_vars_from(input)
    @rules = input[:rules].dup
    @fields = input[:rules].keys
    @own_ticket = input[:own_ticket]
    @other_tickets = input[:other_tickets]
  end
end

Day16.solve
