require_relative 'bowling/invalid_input_exception'

class Main
    def initialize(results_file_path = nil)
        @results_file_path = results_file_path
    end

    def read_file
        validate_inputs
    end

    private

    def validate_inputs
        validate_file_has_content
        validate_characteres
        validate_scores
    end
    
    def validate_file_has_content
        raise Bowling::InvalidInputException.with_blank_error if @results_file_path.empty?
    end
    
    def validate_characteres
        raise Bowling::InvalidInputException.with_characteres_error unless valid_characteres?
    end

    def valid_characteres?
        @results_file_path.each_line do |line|
            return false unless expected_format?(line)
        end

        true
    end

    def expected_format?(line)
        name_tab_number = /^[a-zA-Z]+\t-?\d+$/
        line.match?(name_tab_number)
    end
    
    def validate_scores
        @results_file_path.each_line do |line|
            validate_line_score(line)
        end
    end
    
    def validate_line_score(line)
        line.chomp.tap do |l|
            score = get_score(l)
            raise Bowling::InvalidInputException.with_negative_score_error if !in_valid_range?(score)
        end
    end

    def get_score(line)
        match_score_regex = /^[a-zA-Z]+\t(-?\d+)$/
        line.match(match_score_regex)[1]
    end

    def in_valid_range?(score)
        (0..10).include?(score.to_i)
    end
end
