require 'spec_helper'
require 'main'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:scores) { file_fixture('scores.txt') }
  
  context 'when starts the program' do
    it 'validate the input rules' do
      input_validator = spy(Bowling::InputValidator)

      subject = described_class.new(perfect, input_validator).read_file
      
      expect(input_validator).to have_received(:validate)
    end

    context 'when input file is invalid' do
      xit 'displays the file error' do
      end
    end

    context 'when input file is valid' do
      it 'get the players scores' do
        input_validator = instance_double(Bowling::InputValidator)
        allow(input_validator).to receive(:validate)
        separated_score = { 
          "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10", "10",
            "10", "10"] 
        }

        subject = described_class.new(perfect, input_validator).read_file

        expect(subject).to eq({ 
          "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10", "10",
            "10", "10"] }
        )
      end

      xit 'processes the game score rules' do
      end
      
      context 'with one player' do
        it 'get the players scores' do
          input_validator = instance_double(Bowling::InputValidator)
          allow(input_validator).to receive(:validate)
          separated_score = { 
            "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10",
              "10", "10", "10"] 
          }
  
          subject = described_class.new(perfect, input_validator).read_file

          expect(subject).to eq({ 
            "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10",
              "10", "10", "10"] }
          )
        end

        context 'and game rules are invalid' do
          context 'with invalid number of throwings' do
            xit 'raises the corresponding error message' do
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
