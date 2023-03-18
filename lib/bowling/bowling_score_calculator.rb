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
            @frames_scores = {
                'frames_score' => {},
                'score_by_frame' => []
            }
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
                            @frames_scores['score_by_frame'] << ['strike', 'X']
                            actual_chance += step_1
                        elsif spare?(actual_chance)
                            frame_score = @spare.score_for(actual_chance, 
                                @chances)
                            pinsfalls = @chances[actual_chance]
                            #convert to characters
                            pinfalls = 'F' if pinfalls == 0
                            @frames_scores['score_by_frame'] << [pinsfalls, '/']
                            actual_chance += step_2
                        else
                            frame_score = @regular.score_for(actual_chance,
                                @chances)
                            actual_pinsfalls = @chances[actual_chance]
                            next_pinsfalls = @chances[actual_chance + 1]
                            #convert into characteres
                            actual_pinsfalls = 'F' if actual_pinsfalls == 0
                            next_pinsfalls = 'F' if next_pinsfalls == 0
                            @frames_scores['score_by_frame'] << 
                                [actual_pinsfalls, next_pinsfalls]
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

            #convert into characteres
            #if strikes
            actual_score = 'X' if actual_score == 10
            next_score = 'X' if next_score == 10
            last_score = 'X' if last_score == 10
            #if fouls
            actual_score = 'F' if actual_score == 0
            next_score = 'F' if next_score == 0
            last_score = 'F' if last_score == 0
            
            if strike?(actual_chance)
                @frames_scores['score_by_frame'] << ['X', next_score, 
                    last_score]
                #convert into numbers to sum framescore
                    #if strikes
                next_score = 10 if next_score == 'X'
                last_score = 10 if last_score == 'X'
                    #if fouls
                next_score = 0 if next_score == 'F'
                last_score = 0 if last_score == 'F'
                #increment frame_score
                frame_score += STRIKE_SCORE + next_score + last_score
                #increments bonus chance
                @bonus_chances += 1
            elsif spare?(actual_chance)
                @frames_scores['score_by_frame'] << [actual_score, '/', 
                    last_score]
                #convert into numbers to sum framescore
                    #if strikes
                last_score = 10 if last_score == 'X'
                    #if fouls
                last_score = 0 if last_score == 'F'
                #increment frame_score
                frame_score += STRIKE_SCORE + last_score
                #increments bonus chance
                @bonus_chances += 1
            else
                @frames_scores['score_by_frame'] << [actual_score, next_score, 
                    'F']
                #convert into numbers to sum framescore
                    #if strikes
                actual_score = 10 if actual_score == 'X'
                next_score = 10 if next_score == 'X'
                    #if fouls
                actual_score = 0 if actual_score == 'F'
                next_score = 0 if next_score == 'F'
                #increment frame score
                frame_score += actual_score + next_score
            end
    
            @total_score += frame_score
        end
        
        def build_frames_scores(actual_frame)
            @frames_scores['frames_score'][actual_frame] = @total_score
        end
    end
end
