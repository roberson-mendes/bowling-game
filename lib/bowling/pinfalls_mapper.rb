module Bowling
  class PinfallsMapper
    MAX_PINS = 10
    STRIKE_SCORE = 10
    FOUL = 0

    def self.to_numbers(pinfalls)
      converted = []
      pinfalls.each_with_index do |pinsfall, idx|
        if %w[x X].include?(pinsfall)
          converted << 10
        elsif %w[f F].include?(pinsfall)
          converted << 0
        elsif pinsfall == '/'
          previous_pinsfall = pinfalls[idx - 1]
          pinsfall = MAX_PINS - previous_pinsfall
          converted << pinsfall
        else
          converted << pinsfall.to_i
        end
      end

      converted
    end

    def self.to_character(_previous_pinfalls = nil, actual_pinfalls)
      return 'F' if actual_pinfalls == FOUL
      return 'X' if actual_pinfalls == STRIKE_SCORE

      actual_pinfalls
    end
  end
end
