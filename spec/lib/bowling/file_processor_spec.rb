require 'spec_helper'
require "bowling/file_processor"

RSpec.describe Bowling::FileProcessor do
  context "when input file is valid" do
    let(:perfect) { file_fixture('perfect.txt') }

    context "with one player" do
      it "get the players scores" do
        input_validator_instance = instance_double(Bowling::InputValidator)
        input_validator_class = class_double(Bowling::InputValidator)
        allow(input_validator_class).to receive(:new)
          .with(perfect)
          .and_return(input_validator_instance)
        allow(input_validator_instance).to receive(:validate)
        separated_score = {
          "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10",
                     "10", "10", "10"],
        }

        subject = described_class.new(perfect, input_validator_class).get_players_scores

        expect(subject).to eq({
                                "Carl" => ["10", "10", "10", "10", "10", "10",
                                           "10", "10", "10", "10", "10", "10"],
                              })
      end
    end

    context "with two players" do
      xit 'separates the two players scores'
    end
  end
end
