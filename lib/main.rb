require 'bowling/file_processor'
class Main
  def initialize(
    results_file_path = nil,
    file_processor = Bowling::FileProcessor
  )
    @results_file_path = results_file_path
    @file_processor = file_processor.new(@results_file_path)
  end

  def read_file
    @file_processor.validate

    #separate player and throwings from each line
    @file_processor.get_players_scores
    #pass each player and throwings to game rules to take its scores
    #calculate game rules
    #print computed scores
  end
end
