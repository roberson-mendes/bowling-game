module Bowling
  module BowlingScoreStrategy
    class Spare
      MAX_PINS = 10

      def score_for(actual_pins_falls, pins_falls)
        first_from_next_frame = pins_falls[actual_pins_falls + 2]
        MAX_PINS + first_from_next_frame
      end
    end
  end
end
