module Bowling
  module Validator
    class ScoreValidator
      def initialize(results_file_path)
        @results_file_path = results_file_path
      end

      def validate
        @results_file_path.each_line do |line|
          line = line.chomp
          validate_line_score(line)
        end
      end

      private

      def validate_line_score(line)
        line.chomp.tap do |l|
          validate_score_characteres(line)
          validate_range(line)
        end
      end

      def validate_score_characteres(line)
        raise Bowling::Validator::InvalidInputException
          .with_invalid_score unless valid_characteres?(line)
      end

      def valid_characteres?(line)
        match_score_regex = /(-?\d+|[fxFX]|[\/])$/

        line.match?(match_score_regex)
      end

      def validate_range(line)
        score = get_score(line)
        raise Bowling::Validator::InvalidInputException
          .with_negative_score_error unless in_valid_range?(score)
      end

      def get_score(line)
        match_score_regex = /^[a-zA-Z]+\t(-?\d+|[fxFX]|[\/])$/

        line.match(match_score_regex)[1]
      end

      def in_valid_range?(score)
        #once the values is 'F', 'x' or '/' it is converted to 0
        #and this test passes
        (0..10).include?(score.to_i)
      end
    end
  end
end
