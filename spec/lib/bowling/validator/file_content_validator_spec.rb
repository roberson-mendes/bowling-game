require 'spec_helper'
require 'bowling/validator/file_content_validator'
require 'bowling/validator/invalid_input_exception'

RSpec.describe Bowling::Validator::FileContentValidator do
    let(:empty) { file_fixture('empty.txt') }

    context 'with empty file' do
        it 'raises the corresponding error message' do
            empty_exception_message = "File can't be empty."
            invalid_input_exception_class = Bowling::Validator::InvalidInputException
        
            subject = described_class.new(empty)
        
            expect{ subject.validate }.to raise_exception(invalid_input_exception_class, empty_exception_message)
        end
    end
end