module Bowling
  module BowlingScoreStrategy
    class Strike
      STRIKE_SCORE = 10

      def initialize
        @strikes = 0
      end

      def score_for(actual_chance, chances)
        skip_1 = actual_chance + 1
        skip_2 = actual_chance + 2
        next_chance = chances[skip_1]
        next_next_chance = chances[skip_2]
        @strikes += 1

        STRIKE_SCORE + next_chance + next_next_chance
      end

      def strikes
        @strikes
      end
    end
  end
end
