require 'spec_helper'
require 'main'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'
require 'bowling/file_processor'
require 'bowling/bowling_score_calculator'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:scores) { file_fixture('scores.txt') }
  
  context 'when starts the program' do
    it 'process the file' do
      file_processor = spy(Bowling::FileProcessor)
      bowling_score_calculator = class_double(Bowling::BowlingScoreCalculator)
      bowling_score_calculator_instance = instance_double(Bowling::BowlingScoreCalculator)
      allow(bowling_score_calculator).to receive(:new)
        .with(anything)
        .and_return(bowling_score_calculator_instance)
      allow(bowling_score_calculator_instance).to receive(:calculate)

      subject = described_class.new(
        perfect, 
        file_processor: file_processor,
        bowling_score_calculator: bowling_score_calculator
      ).read_file
      
      expect(file_processor).to have_received(:get_players_scores)
    end

    it 'calculates the game rules to one player' do
      bowling_score_calculator = class_double(Bowling::BowlingScoreCalculator)
      bowling_score_calculator_instance = instance_double(Bowling::BowlingScoreCalculator)
      player_scores = ["10", "10", "10", "10", "10", "10", "10", "10", "10",
        "10", "10", "10"]
      allow(bowling_score_calculator).to receive(:new)
        .with(player_scores)
        .and_return(bowling_score_calculator_instance)
      allow(bowling_score_calculator_instance).to receive(:calculate)

      subject = described_class.new(
        perfect,
        bowling_score_calculator: bowling_score_calculator
      ).read_file
      
      expect(bowling_score_calculator).to have_received(:new)
        .with(player_scores)
    end

    xit 'calculates the game rules to each palyer' do
    end

    xit 'prints the game score' do

    end

    context 'when input file is invalid' do
      xit 'prints the file error' do
      end
    end

    context 'when input file is valid' do
      context 'with one player' do
        context 'and game rules are invalid' do
          context 'with invalid number of throwings' do
            xit 'prints the corresponding error message' do
            end
          end
        end

        context 'and game rules are valid' do
          context 'with strikes in all throwings' do
            xit 'prints a perfect game scoreboard' do
            end
          end
          
          context 'with fouls in all throwings' do
            xit 'prints the game scoreboard to stdout' do
            end
          end
        end
      end

      context 'with more than two players' do
        xit 'prints the game scoreboard to stdout' do
        end
      end
    end
  end
end
