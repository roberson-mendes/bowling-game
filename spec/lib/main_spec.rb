require 'spec_helper'
require 'main'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }

  context 'when input file is valid' do
    context 'with more than two players' do
      xit 'prints the game scoreboard to stdout' do
      end
    end

    context 'with strikes in all throwings' do
      xit 'prints a perfect game scoreboard' do
      end
    end

    context 'with fouls in all throwings' do
      xit 'prints the game scoreboard to stdout' do
      end
    end
  end
  
  context 'with invalid number of throwings' do
    xit 'raises the corresponding error message' do
    end
  end

  context 'when validating an input file' do
    it 'calls input_validator to validate the file' do
      input_validator = spy(Bowling::InputValidator)

      subject = described_class.new(perfect, input_validator).read_file
      
      expect(input_validator).to have_received(:validate)
    end
  end
end
