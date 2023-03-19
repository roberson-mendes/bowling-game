module Bowling
  class PinfallsMapper
    MAX_PINS = 10
    STRIKE_SCORE = 10
    FOUL = 0

    def self.to_numbers(pinfalls)
      converted = []
      pinfalls.each_with_index do |pinsfall, idx|
        if pinsfall == "x" || pinsfall == "X"
          converted << 10
        elsif pinsfall == "f" || pinsfall == "F"
          converted << 0
        elsif pinsfall == "/"
          previous_pinsfall = pinfalls[idx - 1]
          pinsfall = MAX_PINS - previous_pinsfall
          converted << pinsfall
        else
          converted << pinsfall.to_i
        end
      end

      converted
    end

    def self.to_character(previous_pinfalls = nil, actual_pinfalls)
      return "F" if actual_pinfalls == FOUL
      return "X" if actual_pinfalls == STRIKE_SCORE 
      return actual_pinfalls
    end
  end
end
