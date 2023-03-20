module Bowling
  module Validator
    class FileContentValidator
      def initialize(results_file_path)
        @results_file_path = results_file_path
      end

      def validate
        return unless @results_file_path.empty?

        raise Bowling::Validator::InvalidInputException
          .with_blank_error
      end
    end
  end
end
