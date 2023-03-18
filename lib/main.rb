require 'bowling/file_processor'
require 'bowling/bowling_score_calculator'
require 'pry-byebug'

class Main
  def initialize(
    results_file_path = nil,
    overrides = {}
  )
    @results_file_path = results_file_path
    @file_processor = overrides.fetch(:file_processor) do
      Bowling::FileProcessor.new(@results_file_path)
    end
    @bowling_score_calculator = overrides.fetch(:bowling_score_calculator) do
      Bowling::BowlingScoreCalculator
    end
  end

  def read_file
    players_pinfalls = @file_processor.get_players_scores
    #calculate the players scores
    #separate it in an iterator pattern
    players_scores = []
    pinfalls = players_pinfalls.first[1]
    @bowling_score_calculator.new(pinfalls).calculate
      #entrada: ["10", "7", "3", "9", "0", "10", "0", "8", "8", "2", "0", "6",
      # "10", "10", "10", "8", "1"]
      
      #saída: 
      # "frames_score" => {
      #   1 => 20,
      #   2 => 39,
      #   3 => 48,
      #   4 => 66,
      #   5 => 74,
      #   6 => 84,
      #   7 => 90,
      #   8 => 120,
      #   9 => 148,
      #   10 => 167,
      # },
      # "score_by_frame" => [["strike", "X"], [7, "/"], [9, "F"],
      #                      ["strike", "X"], ["F", 8], [8, "/"], ["F", 6], 
      #                      ["strike", "X"], ["strike", "X"], ["X", 8, 1]],
      # }

      #saída final:
      # [
      #   {
      #     "name" => "Carl",
      #     "scores" => {
      #       "frames_score" => {
      #         1 => 30,
      #         2 => 60,
      #         3 => 90,
      #         4 => 120,
      #         5 => 150,
      #         6 => 180,
      #         7 => 210,
      #         8 => 240,
      #         9 => 270,
      #         10 => 300
      #       },
      #       "score_by_frame" => [
      #         ["strike", "X"], ["strike", "X"],
      #         ["strike", "X"], ["strike", "X"],
      #         ["strike", "X"], ["strike", "X"],
      #         ["strike", "X"], ["strike", "X"],
      #         ["strike", "X"], ["X", "X", "X"],
      #       ],
      #     },
      #   },
      # ]
    #print computed scores
  end
end
