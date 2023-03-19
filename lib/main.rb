require 'bowling/file_processor'
require 'bowling/bowling_score_calculator'
require 'bowling/printer'
require 'bowling/validator/invalid_input_exception'
require 'logger'

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
    @printer = overrides.fetch(:printer) do
      Bowling::Printer.new
    end
    @logger = overrides.fetch(:logger) do
      Logger.new(STDOUT)
    end
  end

  def read_file
    begin
      players_pinfalls = @file_processor.get_players_scores
      players_scores = calculate_players_scores(players_pinfalls)
      @printer.print_game_result(players_scores)
    rescue Bowling::Validator::InvalidInputException => error
      print ("\n Invalid file: #{error.message}")
      @logger.error(error.backtrace)
      raise error
    rescue => error
      print ("\n Some problem ocurred. The problem is: #{ error.message }")
      @logger.error("\nThe error stacktrace is: #{error.backtrace}\n")
      raise error
    end
  end
  
  private
  
  def calculate_players_scores(players_pinfalls)
    players_scores = []
    
    players_pinfalls.each do |name, pinfalls|
      bowling_score = @bowling_score_calculator.new.calculate(pinfalls)
      player_score = build_players_scores(name, bowling_score)
      # add_player to players scores
      players_scores << player_score
    end
    
    players_scores
  end

  def build_players_scores(name, bowling_score)
    player_score = {
      'name' => name,
      'scores' => bowling_score
    }
  end
end
