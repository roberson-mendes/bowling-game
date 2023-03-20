module Bowling
  module BowlingScoreStrategy
    class Strike
      attr_reader :strikes

      STRIKE_SCORE = 10

      def initialize
        @strikes = 0
      end

      def score_for(actual_chance, chances)
        next_chance = chances[actual_chance + 1]
        next_next_chance = chances[actual_chance + 2]
        @strikes += 1

        STRIKE_SCORE + next_chance + next_next_chance
      end
    end
  end
end
