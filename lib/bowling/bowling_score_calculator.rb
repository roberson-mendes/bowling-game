require 'bowling/chances_validator'
require 'bowling/pinfalls_mapper'
require 'bowling/bowling_score_strategy/strike'
require 'bowling/bowling_score_strategy/spare'
require 'bowling/bowling_score_strategy/regular'
require 'pry-byebug'
module Bowling
    class BowlingScoreCalculator
        MAX_PINS = 10
        STRIKE_SCORE = 10
        MAX_CHANCES = 20
    
        def initialize(chances, overrides = {})
            @bonus_chances = 0
            @total_score = 0
            @frames_scores = {}
            @pinfalls_mapper = overrides.fetch(:score_mapper) do
                Bowling::PinfallsMapper
            end
            @chances = @pinfalls_mapper.to_numbers(chances)
            @chances_validator = overrides.fetch(:chances_validator) do
                Bowling::ChancesValidator.new(@chances)
            end
            @strike = overrides.fetch(:strike) do
                Bowling::BowlingScoreStrategy::Strike.new
            end
            @spare = overrides.fetch(:spare) do
                Bowling::BowlingScoreStrategy::Spare.new
            end
            @regular = overrides.fetch(:regular) do
                Bowling::BowlingScoreStrategy::Regular.new
            end
        end
    
        def calculate
            actual_chance = 0
            actual_frame = 1
    
            until last_chance?(actual_chance)
                frame_score = 0
                step_1 = 1
                step_2 = 2
                frames = (1..10)
    
                frames.each do |actual_frame|
                    unless last_frame?(actual_frame)
                        if strike?(actual_chance)
                            frame_score = @strike.score_for(actual_chance, 
                                @chances)
                            actual_chance += step_1
                        elsif spare?(actual_chance)
                            frame_score = @spare.score_for(actual_chance, 
                                @chances)
                            actual_chance += step_2
                        else
                            frame_score = @regular.score_for(actual_chance,
                                @chances)
                            actual_chance += step_2
                        end
        
                        @chances_validator.validate_next_chance(actual_chance)
                        
                        @total_score += frame_score
                    end
        
                    if last_frame?(actual_frame)
                        frame_score = score_for_last_frame(actual_chance)
                        actual_chance = transform_to_last(actual_chance)
                    end
        
                    build_frames_scores(actual_frame)
                end
            end
    
            
            @chances_validator.validate_chances_quantity(@strike.strikes, 
                @bonus_chances)

            @frames_scores
        end

        private
        
        def transform_to_last(actual_chance)
            skip_2_chances = actual_chance + 2
            last_chance = skip_2_chances
            actual_chance += last_chance
        end
    
        def last_chance?(chance)
            last_chance = @chances.size - 1
    
            chance >= last_chance
        end
    
        def last_frame?(frame)
            last_frame = 10
    
            frame >= last_frame
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
        
        def build_frames_scores(actual_frame)
            @frames_scores[actual_frame] = @total_score
        end
    end
end
