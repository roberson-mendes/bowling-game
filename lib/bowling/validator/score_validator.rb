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
        line.chomp.tap do |_l|
          validate_score_characteres(line)
          validate_range(line)
        end
      end

      def validate_score_characteres(line)
        return if valid_characteres?(line)

        raise Bowling::Validator::InvalidInputException
          .with_invalid_score
      end

      def valid_characteres?(line)
        match_score_regex = %r{(-?\d+|[fxFX]|/)$}

        line.match?(match_score_regex)
      end

      def validate_range(line)
        score = get_score(line)
        return if in_valid_range?(score)

        raise Bowling::Validator::InvalidInputException
          .with_negative_score_error
      end

      def get_score(line)
        match_score_regex = %r{^[a-zA-Z]+\t(-?\d+|[fxFX]|/)$}

        line.match(match_score_regex)[1]
      end

      def in_valid_range?(score)
        (0..10).include?(score.to_i)
      end
    end
  end
end
