require "bowling/chances_validator"
require "bowling/pinfalls_mapper"
require "bowling/bowling_score_strategy/strike"
require "bowling/bowling_score_strategy/spare"
require "bowling/bowling_score_strategy/regular"

module Bowling
  class BowlingScoreCalculator
    MAX_PINS = 10
    STRIKE_SCORE = 10
    MAX_CHANCES = 20

    def initialize(overrides = {})
      @bonus_chances = 0
      @total_score = 0
      @frames_scores = {
        "frames_score" => {},
        "score_by_frame" => [],
      }
      @pinfalls_mapper = overrides.fetch(:score_mapper) do
        Bowling::PinfallsMapper
      end
      @chances_validator = overrides.fetch(:chances_validator) do
        Bowling::ChancesValidator.new
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

    def calculate(chances)
      @chances = @pinfalls_mapper.to_numbers(chances)

      actual_chance = 0
      until last_chance?(actual_chance)
        frame_score = 0
        frames = (1..10)

        frames.each do |actual_frame|          
          if last_frame?(actual_frame)
            frame_score = compute_last_frame_score(actual_chance)
            actual_chance = transform_to_last(actual_chance)
          else
            if strike?(actual_chance)
              frame_score = compute_strike_frame_score(actual_chance)
              actual_chance += 1
            elsif spare?(actual_chance)
              frame_score = compute_spare_frame_score(actual_chance)
              actual_chance += 2
            else
              frame_score = compute_regular_frame_score(actual_chance)
              actual_chance += 2
            end

            @chances_validator.validate_next_chance(@chances, actual_chance)
          end
          
          adds_to_total_score(frame_score)
          adds_to_frames_scores(actual_frame)
        end
      end

      @chances_validator.validate_chances_quantity(@strike.strikes,
                                                   @bonus_chances)

      @frames_scores
    end

    private

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

      @chances_validator.validate_next_chance(@chances, actual_chance)
      actual_pins_down + next_pins_down == MAX_PINS
    end

    def compute_strike_frame_score(actual_chance)
      add_strike_frame
      @strike.score_for(actual_chance,
                        @chances)
    end
    
    def compute_spare_frame_score(actual_chance)
      add_spare_frame_score(actual_chance)
      @spare.score_for(actual_chance,
                       @chances)
    end

    def compute_regular_frame_score(actual_chance)
      add_regular_frame_score(actual_chance)
      @regular.score_for(actual_chance,
                         @chances)
    end

    def adds_to_total_score(frame_score)
      @total_score += frame_score
    end

    def last_chance?(chance)
      last_chance = @chances.size - 1

      chance >= last_chance
    end

    def transform_to_last(actual_chance)
      skip_2_chances = actual_chance + 2
      last_chance = skip_2_chances
      actual_chance += last_chance
    end

    def add_strike_frame
      @frames_scores["score_by_frame"] << ["strike", "X"]
    end

    def add_spare_frame_score(actual_chance)
      pinsfalls = @chances[actual_chance]
      pinfalls = @pinfalls_mapper.to_character(pinsfalls)
      @frames_scores["score_by_frame"] << [pinsfalls, "/"]
    end

    def add_regular_frame_score(actual_chance)
      pinfalls_characteres = convert_into_characteres(actual_chance)

      @frames_scores["score_by_frame"] << [
        pinfalls_characteres['actual_pinfalls'],
        pinfalls_characteres['next_pinsfalls']
      ]
    end

    def convert_into_characteres(actual_chance)
      actual_pinfalls = @chances[actual_chance]
      next_pinfalls = @chances[actual_chance + 1]

      {
        'actual_pinfalls' => @pinfalls_mapper.to_character(actual_pinfalls),
        'next_pinsfalls' => @pinfalls_mapper.to_character(next_pinfalls)
      }
    end

    def compute_last_frame_score(actual_chance)
      actual_pinfalls = @chances[actual_chance]
      next_pinfalls = @chances[actual_chance + 1]
      last_pinfalls = @chances[actual_chance + 2]

      if strike?(actual_chance)
        build_last_frame_with_strike(actual_chance)
        @bonus_chances += 1
        return STRIKE_SCORE + next_pinfalls + last_pinfalls
      elsif spare?(actual_chance)
        build_last_frame_with_spare(actual_chance)
        @bonus_chances += 1
        return STRIKE_SCORE + last_pinfalls
      else
        build_last_frame_with_regular(actual_chance)
        return actual_pinfalls + next_pinfalls
      end
    end

    def build_last_frame_with_strike(actual_chance)
      next_pinfalls = @chances[actual_chance + 1]
      last_pinfalls = @chances[actual_chance + 2]

      last_pinfalls = "/" if spare?(actual_chance + 1)
      next_pinfalls = @pinfalls_mapper.to_character(next_pinfalls)
      last_pinfalls = @pinfalls_mapper.to_character(next_pinfalls, last_pinfalls)

      @frames_scores["score_by_frame"] << ["X", next_pinfalls,
                                           last_pinfalls]
    end

    def build_last_frame_with_spare(actual_chance)
      next_pinfalls = @chances[actual_chance + 1]
      last_pinfalls = @chances[actual_chance + 2]

      last_pinfalls = @pinfalls_mapper.to_character(last_pinfalls)

      @frames_scores["score_by_frame"] << [actual_pinfalls, "/",
                                           last_pinfalls]
    end

    def build_last_frame_with_regular(actual_chance)
      actual_pinfalls = @chances[actual_chance]
      next_pinfalls = @chances[actual_chance + 1]
      last_pinfalls = @chances[actual_chance + 2]

      actual_pinfalls = @pinfalls_mapper.to_character(actual_pinfalls)
      next_pinfalls = @pinfalls_mapper.to_character(next_pinfalls)
      last_pinfalls = @pinfalls_mapper.to_character(last_pinfalls)

      @frames_scores["score_by_frame"] << [actual_pinfalls, next_pinfalls,
                                           "-"]
    end

    def adds_to_frames_scores(actual_frame)
      @frames_scores["frames_score"][actual_frame] = @total_score
    end
  end
end
