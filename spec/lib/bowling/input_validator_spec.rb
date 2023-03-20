require 'spec_helper'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'

RSpec.describe Bowling::InputValidator do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:invalid_score) { file_fixture('invalid-score.txt') }

  context 'when validating a file' do
    it 'calls its validators correctly' do
      validator_instance = spy('ValidatorInstance')
      validators = [validator_instance]

      subject = described_class.new(perfect, validators: validators).validate

      expect(validator_instance).to have_received(:validate)
    end
  end
end
