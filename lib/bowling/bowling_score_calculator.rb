require 'bowling/chances_validator'
require 'bowling/pinfalls_mapper'
module Bowling
    class BowlingScoreCalculator
        MAX_PINS = 10
        STRIKE_SCORE = 10
        MAX_CHANCES = 20
    
        def initialize(chances, overrides = {})
            @bonus_chances = 0
            @strikes = 0
            @total_score = 0
            @frames_scores = {}
            @pinfalls_mapper = overrides.fetch(:score_mapper) do
                Bowling::PinfallsMapper
            end
            @chances = @pinfalls_mapper.to_numbers(chances)
            @chances_validator = overrides.fetch(:chances_validator) do
                Bowling::ChancesValidator.new(@chances)
            end
        end
    
        def calculate
            actual_chance = 0
            actual_frame = 1
    
            until last_chance?(actual_chance)
                frame_score = 0
                step_1 = 1
                step_2 = 2
    
                unless last_frame?(actual_frame)
                    if strike?(actual_chance)
                        frame_score = score_for_strike(actual_chance)
                        actual_chance += step_1
                    elsif spare?(actual_chance)
                        frame_score = score_for_spare(actual_chance)
                        actual_chance += step_2
                    else
                        frame_score = score_for_regular(actual_chance)
                        actual_chance += step_2
                    end
    
                    @chances_validator.validate_next_chance(actual_chance)
                    
                    @total_score += frame_score
                end
    
                if last_frame?(actual_frame)
                    frame_score = score_for_last_frame(actual_chance)
                    skip_2_chances = actual_chance + 2
                    last_chance = skip_2_chances
                    actual_chance += last_chance
                end
    
                @frames_scores[actual_frame] = @total_score
                actual_frame += 1
            end
    
            @chances_validator.validate_chances_quantity(@strikes, @bonus_chances)

            @frames_scores
        end

        private

        def convert_to_numbers(scores)
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
    
        def last_chance?(chance)
            last_chance = @chances.size - 1
    
            chance >= last_chance
        end
    
        def last_frame?(frame)
            last_frame = 10
    
            frame >= last_frame
        end
    
        def score_for_strike(actual_chance)
            @strikes += 1
            skip_1 = actual_chance + 1
            skip_2 = actual_chance + 2
            next_chance = @chances[skip_1]
            next_next_chance = @chances[skip_2]
    
            STRIKE_SCORE + next_chance + next_next_chance
        end
    
        def score_for_spare(actual_chance)
            first_from_next_frame = @chances[actual_chance + 2]
            MAX_PINS + first_from_next_frame
        end
    
        def score_for_regular(actual_chance)
            next_chance = actual_chance + 1
            @chances[actual_chance] + @chances[next_chance]
        end
    
        def strike?(chance)
            @chances[chance] == STRIKE_SCORE
        end
    
        def spare?(actual_chance)
            next_pins_down = @chances[actual_chance + 1]
            actual_pins_down = @chances[actual_chance]
    
            @chances_validator.validate_next_chance(actual_chance)
            actual_pins_down + next_pins_down >= MAX_PINS
        end
    
        def score_for_last_frame(actual_chance)
            frame_score = 0
            actual_score = @chances[actual_chance]
            skip_1 = actual_chance + 1
            skip_2 = actual_chance + 2
            next_score = @chances[skip_1]
            last_score = @chances[skip_2]
    
            if strike?(actual_chance)
                frame_score += STRIKE_SCORE + next_score + last_score
                @bonus_chances += 1
            elsif spare?(actual_chance)
                frame_score += STRIKE_SCORE + last_score
                @bonus_chances += 1
            else
                frame_score += actual_score + next_score
            end
    
            @total_score += frame_score
        end
    
        def valid_quantity?
            chances_quantity = @chances.size
            
            chances_quantity == MAX_CHANCES - @strikes + @bonus_chances
        end
    end
end
