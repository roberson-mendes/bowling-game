require_relative 'bowling/bowling_score_calculator'

class ScoresBuilder
  def initialize(overrides={})
    @bowling_score_calculator = overrides.fetch(:bowling_score_calculator) do
      Bowling::BowlingScoreCalculator
    end
  end

  def build_players_scores(players_pinfalls)
    players_scores = []

    players_pinfalls.each do |name, pinfalls|
      bowling_score = @bowling_score_calculator.new.calculate(pinfalls)
      player_score = build_player_scores(name, bowling_score)
      # add_player to players scores
      players_scores << player_score
    end

    players_scores
  end

  private

  def build_player_scores(name, bowling_score)
    player_score = {
      "name" => name,
      "scores" => bowling_score,
    }
  end
end