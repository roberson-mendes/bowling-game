module Bowling
  module Validator
    class FileContentValidator
      def initialize(results_file_path)
        @results_file_path = results_file_path
      end

      def validate
        raise Bowling::Validator::InvalidInputException
          .with_blank_error if @results_file_path.empty?
      end
    end
  end
end
