require_relative 'scores_builder'
require_relative 'bowling/file_processor'
require_relative 'bowling/printer'
require_relative 'bowling/validator/invalid_input_exception'
require 'logger'
class BowlingGame
  def initialize(results_file_path, overrides = {})
    @results_file_path = results_file_path
    @logger = Logger.new($stdout)
    @scores_builder = overrides.fetch(:scores_builder) do
      ScoresBuilder.new
    end
    @file_processor = overrides.fetch(:file_processor) do
      Bowling::FileProcessor.new(@results_file_path)
    end
    @printer = overrides.fetch(:printer) do
      Bowling::Printer.new
    end
  end

  def process_game_file
    players_pinfalls = @file_processor.players_scores
    players_scores = @scores_builder
                     .build_players_scores(players_pinfalls)
    print @printer.print_game_result(players_scores)
  rescue Bowling::Validator::InvalidInputException => e
    puts("Invalid file: #{e.message}")
    @logger.error(e.backtrace)
    raise e
  rescue StandardError => e
    puts("Some problem ocurred. Problem message #{e.message}")
    @logger.error("\nThe error stacktrace is: #{e.backtrace}\n")
    raise e
  end
end
