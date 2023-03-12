require_relative 'bowling/invalid_input_exception'

class Main
    def initialize(results_file_path = nil)
        @results_file_path = results_file_path
    end

    def read_file
        raise Bowling::InvalidInputException unless valid_inputs?
    end

    private

    def valid_inputs?
        return false if @results_file_path.empty?
        #TODO: check whether the players inputs are corrects
        return false unless valid_scores?

        true
    end
    
    def valid_scores?
        @results_file_path.each_line do |line|
            return false unless valid_line_score?(line)
        end
        
        true
    end
    
    def valid_line_score?(line)
        line.chomp.tap do |l|
            score = get_score(l)
            return false unless in_valid_range?(score)
        end

        true
    end

    def get_score(player_input)
        match_score_regex = /(\w+)\t(\d+)$/
        player_input.match(match_score_regex)
    end

    def in_valid_range?(score)
        (0..10).include?(score)
    end
end
