module Bowling
  class ChancesValidator
    MAX_PINS = 10
    MAX_CHANCES = 20
    STRIKE_SCORE = 10

    def validate_next_chance(scores, actual_chance)
      @scores = scores

      actual_pins = @scores[actual_chance]
      next_pins = @scores[actual_chance + 1]
      raise 'Less chances then the required by bowling rules.' if less_chances?(actual_pins)
      raise "Chance #{actual_chance + 1} is invalid" unless next_chance_valid?(actual_pins, next_pins)
    end

    def validate_chances_quantity(strikes, bonus_chances)
      chances_quantity = @scores.size
      actual_max_chances = (MAX_CHANCES - strikes + bonus_chances)

      raise 'More chances then the required by bowling rules.' if chances_quantity > actual_max_chances
    end

    private

    def next_chance_valid?(actual_pins, next_pins)
      if strike?(actual_pins)
        double_strike = 20
        actual_pins + next_pins <= double_strike
      elsif spare?(actual_pins, next_pins)
        actual_pins + next_pins == MAX_PINS
      else
        actual_pins + next_pins < MAX_PINS
      end
    end

    def less_chances?(actual_pins)
      actual_pins.nil?
    end

    def valid_quantity?(strikes, bonus_chances)
      chances_quantity = @scores.size
      actual_max_chances = (MAX_CHANCES - strikes + bonus_chances)
      raise 'More chances then the required by bowling rules.' if chances_quantity >= actual_max_chances

      chances_quantity == actual_max_chances
    end

    def strike?(pins_down)
      pins_down == STRIKE_SCORE
    end

    def spare?(pins_down, next_pins_down)
      pins_down + next_pins_down >= MAX_PINS
    end
  end
end
