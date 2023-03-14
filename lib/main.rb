require_relative 'bowling/validator/invalid_input_exception'

class Main
    def initialize(results_file_path = nil, input_validator = nil)
        @results_file_path = results_file_path
        @input_validator = input_validator
    end

    def read_file
        @input_validator.validate

        #separate player and throwings from each line
        players_scores = {}
        @results_file_path.each_line do |line|
          score_line = get_player_scores(line)
          players_scores[score_line[:name]] ||= []
          players_scores[score_line[:name]] << score_line[:pins]
        end

        players_scores
        #pass each player score to game rules to take its scores
        #calculate game rules
            #validate throwings
        #print computed scores
    end

    def get_player_scores(line)
        player_infos = line.chomp.split("\t")
        
        {
            name: player_infos[0],
            pins: player_infos[1] 
        }
    end
end
  