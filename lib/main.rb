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
        #if it's not empty file
        return false if @results_file_path.empty?
        #if the names are corrects
        #if scores are
            #between 1-10
    end
end
