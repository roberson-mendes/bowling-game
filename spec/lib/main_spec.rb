require 'spec_helper'
require 'main'
require 'bowling/invalid_input_exception'

RSpec.describe Main do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:empty) { file_fixture('empty.txt') }
  let(:invalid_score) { file_fixture('invalid-score.txt') }
  let(:negative) { file_fixture('negative.txt') }
  let(:free_text) { file_fixture('free-text.txt') }

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
    let(:invalid_input_exception_class) { Bowling::InvalidInputException }
    
    context 'with empty file' do
      it 'raises the corresponding error message' do
        empty_exception_message = "File can't be empty."
    
        subject = described_class.new(empty)
    
        expect{ subject.read_file }.to raise_exception(invalid_input_exception_class, empty_exception_message)
      end
    end

    context 'with invalid characters present' do
      it 'raises the corresponding error message' do
        invalid_characteres_exception_message = "Invalid characteres. Each line must be <name><tab><score>"

        subject = described_class.new(free_text)
    
        expect{ subject.read_file }.to raise_exception(invalid_input_exception_class, invalid_characteres_exception_message)
      end
    end

    context 'with invalid score' do
      it 'raises the corresponding error message' do
        invalid_score_error = "Invalid characteres. Each line must be <name><tab><score>"
        
        subject = described_class.new(invalid_score)

        expect{ subject.read_file }.to raise_exception(invalid_input_exception_class, invalid_score_error)
      end
    end

    context 'with negative score' do
      it 'raises the corresponding error message' do
        negative_score_error = "Invalid score. Score must be a number between 0 and 10"

        subject = described_class.new(negative)

        expect{ subject.read_file }.to raise_exception(invalid_input_exception_class, negative_score_error)
      end
    end

    context 'with invalid number of throwings' do
      xit 'raises the corresponding error message' do
      end
    end
  end
end
