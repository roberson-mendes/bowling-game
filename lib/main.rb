require_relative 'bowling/file_processor'
require_relative 'bowling/bowling_score_calculator'
require_relative 'bowling/printer'
require_relative 'bowling/validator/invalid_input_exception'
require_relative 'bowling_game'
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
    @bowling_game = overrides.fetch(:bowling_game) do
      BowlingGame.new
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
      players_scores = @bowling_game.calculate_players_scores(players_pinfalls)
      print @printer.print_game_result(players_scores)
    rescue Bowling::Validator::InvalidInputException => error
      puts ("Invalid file: #{error.message}")
      @logger.error(error.backtrace)
      raise error
    rescue => error
      puts ("Some problem ocurred. Problem message #{ error.message }")
      @logger.error("\nThe error stacktrace is: #{error.backtrace}\n")
      raise error
    end
  end
end
