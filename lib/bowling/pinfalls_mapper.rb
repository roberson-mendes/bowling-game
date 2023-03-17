module Bowling
    class PinfallsMapper
        MAX_PINS = 10
        
        def self.to_numbers(scores)

            converted = []
            scores.each_with_index do |score, idx|
                if score == 'x' || score == 'X'
                    converted << 10
                elsif score == 'f' || score == 'F'
                    converted << 0
                elsif score == '/'
                    previous_score = scores[idx - 1]
                    score = MAX_PINS - previous_score
                    converted << score
                else
                    converted << score.to_i
                end
            end

            converted
        end
    end
end