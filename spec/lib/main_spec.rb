require 'spec_helper'
require 'main'
require 'bowling/invalid_input_exception'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:empty)   { file_fixture('empty.txt') }

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

  context 'when input file is invalid' do
    context 'with empty file' do
      it 'raises the corresponding error message' do
        invalid_input_exception = Bowling::InvalidInputException
    
        subject = described_class.new(empty)
    
        expect{ subject.read_file }.to raise_exception(invalid_input_exception)
      end
    end

    context 'with invalid characters present' do
      xit 'raises the corresponding error message' do
      end
    end

    context 'with invalid score' do
      xit 'raises the corresponding error message' do
      end
    end

    context 'with invalid number of throwings' do
      xit 'raises the corresponding error message' do
      end
    end
  end
end
