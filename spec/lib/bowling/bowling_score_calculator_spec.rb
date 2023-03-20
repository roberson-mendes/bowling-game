require 'bowling/bowling_score_calculator'

RSpec.describe Bowling::BowlingScoreCalculator do
  context 'and game rules are invalid' do
    context 'with less throwings than the allowed' do
      it 'raises the corresponding error message' do
        expected_error = 'Less chances then the required by bowling rules.'
        chances = %w[0 0 0 0 0 0 0 0 0 0 0 0]

        subject = described_class.new

        expect { subject.calculate(chances) }.to raise_exception(expected_error)
      end
    end

    context 'with more throwings than the allowed' do
      it 'raises the corresponding error message' do
        expected_error = 'More chances then the required by bowling rules.'
        chances = %w[10 10 10 10 10 10 10 10 10
                     10 10 10 10]

        subject = described_class.new

        expect { subject.calculate(chances) }.to raise_exception(expected_error)
      end
    end
  end

  context 'and game rules are valid' do
    # extract this conversion to a mapper class
    context 'with characteres scores' do
      it 'convert characteres into integer scores' do
        expected_score = {
          'frames_score' => {
            1 => 20,
            2 => 39,
            3 => 48,
            4 => 66,
            5 => 74,
            6 => 84,
            7 => 90,
            8 => 120,
            9 => 148,
            10 => 167
          },
          'score_by_frame' => [%w[strike X], [7, '/'], [9, 'F'],
                               %w[strike X], ['F', 8], [8, '/'], ['F', 6],
                               %w[strike X], %w[strike X], ['X', 8, 1]]
        }
        chances = %w[X 7 3 9 F x f 8 8 2 0 6
                     10 10 10 8 1]

        subject = described_class.new.calculate(chances)

        expect(subject).to eq(expected_score)
      end
    end

    it 'calculates the score' do
      expected_score = {
        'frames_score' => {
          1 => 20,
          2 => 39,
          3 => 48,
          4 => 66,
          5 => 74,
          6 => 84,
          7 => 90,
          8 => 120,
          9 => 148,
          10 => 167
        },
        'score_by_frame' => [%w[strike X], [7, '/'], [9, 'F'],
                             %w[strike X], ['F', 8], [8, '/'], ['F', 6],
                             %w[strike X], %w[strike X], ['X', 8, 1]]
      }
      chances = %w[10 7 3 9 0 10 0 8 8 2 0 6
                   10 10 10 8 1]

      subject = described_class.new.calculate(chances)

      expect(subject).to eq(expected_score)
    end

    context 'with strikes in all throwings' do
      it 'calculates the score correctly' do
        expected_score = {
          'frames_score' => {
            1 => 30,
            2 => 60,
            3 => 90,
            4 => 120,
            5 => 150,
            6 => 180,
            7 => 210,
            8 => 240,
            9 => 270,
            10 => 300
          },
          'score_by_frame' => [
            %w[strike X], %w[strike X], %w[strike X],
            %w[strike X], %w[strike X], %w[strike X],
            %w[strike X], %w[strike X], %w[strike X],
            %w[X X X]
          ]
        }
        chances = %w[10 10 10 10 10 10 10 10 10 10
                     10 10]

        subject = described_class.new.calculate(chances)

        expect(subject).to eq(expected_score)
      end
    end

    context 'with fouls in all throwings' do
      it 'calculates the score correctly' do
        expected_score = {
          'frames_score' => {
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 0,
            10 => 0
          },
          'score_by_frame' => [%w[F F], %w[F F], %w[F F],
                               %w[F F], %w[F F], %w[F F],
                               %w[F F], %w[F F], %w[F F],
                               ['F', 'F', '-']]
        }
        chances = %w[0 0 0 0 0 0 0 0 0 0 0 0
                     0 0 0 0 0 0 0 0]

        subject = described_class.new.calculate(chances)

        expect(subject).to eq(expected_score)
      end
    end
  end
end
