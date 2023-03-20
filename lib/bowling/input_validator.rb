require_relative "validator/file_content_validator"
require_relative "validator/character_validator"
require_relative "validator/score_validator"

module Bowling
  class InputValidator
    def initialize(results_file_path = nil, overrides = {})
      @results_file_path = results_file_path

      @validators = overrides.fetch(:validators) do
        [Bowling::Validator::FileContentValidator.new(results_file_path),
         Bowling::Validator::CharacterValidator.new(results_file_path),
         Bowling::Validator::ScoreValidator.new(results_file_path)]
      end
    end

    def validate
      @validators.each { |validator| validator.validate }
    end
  end
end
