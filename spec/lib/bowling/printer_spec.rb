require 'bowling/printer'

RSpec.describe Bowling::Printer do
  context 'when prints a valid input' do
    context 'with one player' do
      subject { described_class.new.print_game_result(players_final_scores) }

      context 'and all scores are fouls' do
        let(:players_final_scores) { build_foul_player }

        it 'prints scores correctly' do
          expected_display = header_display + fouls_display

          expect(subject).to eq(expected_display)
        end
      end

      context 'and all scores are strikes' do
        let(:players_final_scores) { build_strike_player }

        it 'prints scores correctly' do
          expected_display = header_display + carl_display

          expect(subject).to eq(expected_display)
        end
      end

      context 'and there are normal scores' do
        let(:players_final_scores) { build_regular_player }

        it 'prints scores correctly' do
          expected_display = header_display + john_display

          expect(subject).to eq(expected_display)
        end
      end
    end

    context 'with two or more players' do
      subject { described_class.new.print_game_result(players_final_scores) }

      let(:players_final_scores) { build_two_players_result }

      it 'prints the expected scores' do
        expected_display = header_display + john_display + jeff_display

        expect(subject).to eq(expected_display)
      end
    end
  end

  private

  def get_head(score_display)
    frame_numbers_newline = /^Frame.+\n/
    score_display.match(frame_numbers_newline)[0]
  end

  def get_name(score_display)
    lines = score_display.split("\n")
    name_position = 1

    lines[name_position]
  end

  def pinfalls_display(score_display)
    lines = score_display.split("\n")
    pinfalls_position = 2

    lines[pinfalls_position]
  end

  def frame_score_display(score_display)
    lines = score_display.split("\n")
    pinfalls_position = 3

    lines[pinfalls_position]
  end

  def build_strike_player
    [
      {
        'name' => 'Carl',
        'scores' => {
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
            %w[strike X], %w[strike X],
            %w[strike X], %w[strike X],
            %w[strike X], %w[strike X],
            %w[strike X], %w[strike X],
            %w[strike X], %w[X X X]
          ]
        }
      }
    ]
  end

  def build_foul_player
    [
      {
        'name' => 'Carl',
        'scores' => {
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
          'score_by_frame' => [
            %w[F F], %w[F F], %w[F F],
            %w[F F], %w[F F], %w[F F],
            %w[F F], %w[F F], %w[F F],
            ['F', 'F', nil]
          ]
        }
      }
    ]
  end

  def fouls_display
    "Carl\n" \
      "Pinfalls\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\t" \
      "F\tF\t-\n" \
      "Score\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\n"
  end

  def carl_display
    "Carl\n" \
      "Pinfalls\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX" \
      "\t\t\tX\tX\tX\tX\n" \
      "Score\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t" \
      "270\t\t300\n"
  end

  def build_regular_player
    [
      {
        'name' => 'John',
        'scores' => {
          'frames_score' => {
            1 => 16,
            2 => 25,
            3 => 44,
            4 => 53,
            5 => 82,
            6 => 101,
            7 => 110,
            8 => 124,
            9 => 132,
            10 => 151
          },
          'score_by_frame' => [
            [3, '/'], [6, 3], %w[strike X], [8, 1], %w[strike X],
            %w[strike X], [9, 'F'], [7, '/'], %w[4 4], ['X', 9, 'F']
          ]
        }
      }
    ]
  end

  def header_display
    "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n"
  end

  def john_display
    "John\n" \
      "Pinfalls\t3\t/\t6\t3\t\t\tX\t8\t1\t\t\tX\t\t\tX\t9\tF\t7\t/\t4" \
      "\t4\tX\t9\tF\n" \
      "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t" \
      "132\t\t151\n"
  end

  def build_two_players_result
    [
      {
        'name' => 'John',
        'scores' => {
          'frames_score' => {
            1 => 16,
            2 => 25,
            3 => 44,
            4 => 53,
            5 => 82,
            6 => 101,
            7 => 110,
            8 => 124,
            9 => 132,
            10 => 151
          },
          'score_by_frame' => [
            [3, '/'], [6, 3], %w[strike X], [8, 1], %w[strike X],
            %w[strike X], [9, 'F'], [7, '/'], [4, 4], ['X', 9, 'F']
          ]
        }
      },
      {
        'name' => 'Jeff',
        'scores' => {
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
          'score_by_frame' => [
            %w[strike X], [7, '/'],
            [9, 'F'], %w[strike X],
            ['F', 8], [8, '/'],
            ['F', 6], %w[strike X],
            %w[strike X], ['X', 8, 1]
          ]
        }
      }
    ]
  end

  def jeff_display
    "Jeff\n" \
      "Pinfalls\t\t\tX\t7\t/\t9\tF\t\t\tX\tF\t8\t8\t/\tF\t6\t\t\tX\t\t" \
      "\tX\tX\t8\t1\n" \
      "Score\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t" \
      "148\t\t167\n"
  end
end
