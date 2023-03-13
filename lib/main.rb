require_relative 'bowling/validator/invalid_input_exception'

class Main
    def initialize(results_file_path = nil, input_validator = nil)
        @results_file_path = results_file_path
        @input_validator = input_validator
    end

    def read_file
        @input_validator.validate
    end
end
