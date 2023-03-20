require 'spec_helper'
require 'bowling/file_processor'

RSpec.describe Bowling::FileProcessor do
  context 'when input file is valid' do
    let(:perfect) { file_fixture('perfect.txt') }
    let(:scores) { file_fixture('scores.txt') }

    context 'with one player' do
      it 'get the players scores' do
        input_validator_instance = instance_double(Bowling::InputValidator)
        input_validator_class = class_double(Bowling::InputValidator)
        allow(input_validator_class).to receive(:new)
          .with(perfect)
          .and_return(input_validator_instance)
        allow(input_validator_instance).to receive(:validate)
        separated_score = {
          'Carl' => %w[10 10 10 10 10 10 10 10 10
                       10 10 10]
        }

        subject = described_class.new(
          perfect,
          input_validator_class
        ).players_scores

        expect(subject).to eq(separated_score)
      end
    end

    context 'with two players' do
      it 'separates the two players scores' do
        input_validator_instance = instance_double(Bowling::InputValidator)
        input_validator_class = class_double(Bowling::InputValidator)
        allow(input_validator_class).to receive(:new)
          .with(scores)
          .and_return(input_validator_instance)
        allow(input_validator_instance).to receive(:validate)
        separated_score = {
          'Jeff' => %w[10 7 3 9 0 10 0 8 8 2 F
                       6 10 10 10 8 1],
          'John' => %w[3 7 6 3 10 8 1 10 10 9 0
                       7 3 4 4 10 9 0]
        }

        subject = described_class.new(
          scores,
          input_validator_class
        ).players_scores

        expect(subject).to eq(separated_score)
      end
    end
  end
end
