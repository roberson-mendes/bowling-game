module Bowling
  module BowlingScoreStrategy
    class Regular
      def score_for(actual_pinfalls, pinfalls)
        next_pinfalls = actual_pinfalls + 1
        pinfalls[actual_pinfalls] + pinfalls[next_pinfalls]
      end
    end
  end
end
