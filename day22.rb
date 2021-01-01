require_relative 'common'

class Day22 < AdventDay
  def main
    game_result = play_game(combat_game_with(input.dup))
    _loser_deck, winner_deck = game_result.sort
    score(winner_deck)
  end

  def alternate
    game_result = play_game(recursive_combat_with(input.dup))
    winner, final_decks = game_result
    winner_deck = final_decks[winner]
    score(winner_deck)
  end

  private

  def score(deck)
    deck.
      reverse.
      zip(1...).
      map { |card, point_value| card * point_value }.
      sum
  end

  def combat_game_with(decks)
    Enumerator.new do |yielder|
      loop do
        break if decks.any?(&:empty?)
        cards_played = decks.map(&:shift)
        _best_card, winner = *cards_played.each_with_index.max
        decks[winner].push(*cards_played.sort.reverse)
        yielder << decks
      end
    end
  end

  def recursive_combat_with(decks)
    rounds_played = Set.new
    Enumerator.new do |yielder|
      loop do
        break yielder << [decks.find_index(&:any?), decks] if decks.any?(&:empty?)
        break yielder << [0, decks] if rounds_played.include? decks.hash
        rounds_played << decks.hash

        cards_played_for_each_deck = decks.map { |deck| [deck.shift, deck] }
        cards_played = cards_played_for_each_deck.map { |card, _| card }
        if cards_played_for_each_deck.all? { |card_value, deck| deck.length >= card_value }
          new_decks = cards_played_for_each_deck.map { |card_value, deck| deck[0...card_value] }

          winner, _final_decks = play_game(recursive_combat_with(new_decks))

          decks[winner].push(cards_played.delete_at(winner))
          decks[winner].push(*cards_played)
          yielder << decks
        else
          _best_card, winner = *cards_played.each_with_index.max
          decks[winner].push(*cards_played.sort.reverse)
          yielder << decks
        end
      end
    end
  end

  def play_game(game)
    game_result = nil
    loop do
      game_result = game.next
    rescue StopIteration
      break
    end
    game_result
  end

  def convert_data(data)
    data.split("\n\n").
      map { |deck| super(deck) }.
      map { |(_name, *cards)| cards.map(&:to_i) }
  end
end

require 'benchmark'

Day22.solve
