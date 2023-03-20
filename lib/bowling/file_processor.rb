require_relative "input_validator"

module Bowling
  class FileProcessor
    def initialize(
      file_path = nil,
      input_validator = Bowling::InputValidator
    )
      @file_path = file_path
      @input_validator = input_validator.new(@file_path)
    end

    def get_players_scores
      @input_validator.validate
      get_players
    end

    private

    def get_players
      players_scores = {}

      @file_path.each_line do |line|
        players_info = get_player(line)
        get_or_initialize_score(players_scores, players_info)
        add_score_to_player(players_scores, players_info)
      end

      players_scores
    end
    
    def get_player(line)
      player_infos = line.chomp.split("\t")

      {
        name: player_infos[0],
        pins: player_infos[1],
      }
    end

    def get_or_initialize_score(players_score, players_info)
      players_score[players_info[:name]] ||= []
    end

    def add_score_to_player(players_score, players_info)
      players_score[players_info[:name]] << players_info[:pins]
    end
  end
end
