require 'spec_helper'
require 'bowling/validator/score_validator'
require 'bowling/validator/invalid_input_exception'

RSpec.describe Bowling::Validator::ScoreValidator do
    let(:negative) { file_fixture('negative.txt') }
    let(:invalid_score) { file_fixture('invalid-score.txt') }
    let(:scores) { file_fixture('scores.txt') }
    let(:invalid_input_exception_class) { Bowling::Validator::InvalidInputException }

    context 'when input file is invalid' do
        context 'with negative score' do
            it 'raises the corresponding error message' do
                negative_score_error = "Invalid score. Score must be a number between 0 and 10"
    
                subject = described_class.new(negative)
    
                expect{ subject.validate }.to raise_exception(invalid_input_exception_class, negative_score_error)
            end
        end

        context 'with invalid score' do
            it 'raises the corresponding error message' do
                invalid_score_error = "Invalid score. Score can have just numbers."
                
                subject = described_class.new(invalid_score)

                expect{ subject.validate }.to raise_exception(invalid_input_exception_class, invalid_score_error)
            end
        end
    end
    
    context 'when input file is valid' do
        context 'with numbers and F or / or X' do
            it 'validates the input correctly' do
                subject = described_class.new(scores)

                expect{ subject.validate }.to_not raise_error
            end
        end
    end
end