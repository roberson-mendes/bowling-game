require 'spec_helper'
require 'bowling/validator/character_validator'
require 'bowling/validator/invalid_input_exception'

RSpec.describe Bowling::Validator::CharacterValidator do
    let(:free_text) { file_fixture('free-text.txt') }
    let(:invalid_input_exception_class) { Bowling::Validator::InvalidInputException }

    context 'with invalid characters present' do
        it 'raises the corresponding error message' do
            invalid_characteres_exception_message = "Invalid characteres. Each line must be <name><tab><score>"

            subject = described_class.new(free_text)
        
            expect{ subject.validate }.to raise_exception(invalid_input_exception_class, invalid_characteres_exception_message)
        end
    end
end