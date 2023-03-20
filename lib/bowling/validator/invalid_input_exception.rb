module Bowling
  module Validator
    class InvalidInputException < StandardError
      def initialize(message = 'generic error: invalid input in file')
        super(message)
      end

      def self.with_blank_error
        Bowling::Validator::InvalidInputException.new(
          "File can't be empty."
        )
      end

      def self.with_characteres_error
        Bowling::Validator::InvalidInputException.new(
          'Invalid characteres. Each line must be <name><tab><score>'
        )
      end

      def self.with_negative_score_error
        Bowling::Validator::InvalidInputException.new(
          'Invalid score. Score must be a number between 0 and 10'
        )
      end

      def self.with_invalid_score
        Bowling::Validator::InvalidInputException.new(
          'Invalid score. Score can have just numbers.'
        )
      end
    end
  end
end
