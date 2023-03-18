require 'spec_helper'
require 'main'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'
require 'bowling/file_processor'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:scores) { file_fixture('scores.txt') }
  
  context 'when starts the program' do
    it 'instantiate file processor' do
      file_processor = spy(Bowling::FileProcessor)

      subject = described_class.new(perfect, file_processor).read_file
      
      expect(file_processor).to have_received(:new).with(perfect)
    end

    it 'calls fileprocessor get_players_scores to process the file' do
      file_processor = spy(Bowling::FileProcessor)

      subject = described_class.new(perfect, file_processor).read_file
      
      expect(file_processor).to have_received(:get_players_scores)
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
