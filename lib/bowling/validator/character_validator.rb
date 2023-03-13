module Bowling
    module Validator
        class CharacterValidator
            def initialize(results_file_path)
                @results_file_path = results_file_path
            end
        
            def validate
                @results_file_path.each_line do |line|
                    raise Bowling::Validator::InvalidInputException.with_characteres_error unless expected_format?(line)
                end
            end
        
            private
        
            def expected_format?(line)
                name_tab_number = /^[a-zA-Z]+\t/
                line.match?(name_tab_number)
            end
        end
    end
end
