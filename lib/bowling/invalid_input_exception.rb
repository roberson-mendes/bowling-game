module Bowling
    class InvalidInputException < StandardError
        def initialize
            super(message: "invalid input in lines file")
        end
    end
end