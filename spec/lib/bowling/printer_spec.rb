require "bowling/printer"
require "pry-byebug"

RSpec.describe Bowling::Printer do
  context "when prints a valid input" do
    context "with one player" do
      subject { described_class.new(players_final_scores).print }

      context "and all scores are fouls" do
        let(:players_final_scores) { build_foul_player }

        it "prints scores correctly" do
          expected_display =
            "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n" +
            "Carl\n" +
            "Pinfalls\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\t" +
              "F\tF\n" +
            "Score\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\n"

          expect(subject).to eq(expected_display)
        end
      end

      context "and all scores are strikes" do
        let(:players_final_scores) { build_strike_player }

        it "prints scores correctly" do
          expected_display = 
            "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n" +
            "Carl\n" +
            "Pinfalls\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX" +
              "\t\t\tX\tX\tX\tX\n" +
            "Score\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t" +
              "270\t\t300\n"

          expect(subject).to eq(expected_display)
        end
      end

      context "and there are normal scores" do
        let(:players_final_scores) { build_regular_player }
        
        it "prints scores correctly" do
          expected_display =
            "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n" +
            "John\n" +
            "Pinfalls\t3\t/\t6\t3\t\t\tX\t8\t1\t\t\tX\t\t\tX\t9\tF\t7\t/\t4" +
              "\t4\tX\t9\tF\n" +
            "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t" +
              "132\t\t151\n"

            expect(subject).to eq(expected_display)
        end
      end
    end

    context "with two or more players" do
      xit "prints the expected scores" do
      end
    end
  end

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
        "name" => "Carl",
        "scores" => {
          "frames_score" => {
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
          "score_by_frame" => [
            ["strike", "X"], ["strike", "X"],
            ["strike", "X"], ["strike", "X"],
            ["strike", "X"], ["strike", "X"],
            ["strike", "X"], ["strike", "X"],
            ["strike", "X"], ["X", "X", "X"],
          ],
        },
      },
    ]
  end

  def build_foul_player
    [
      {
        "name" => "Carl",
        "scores" => {
          "frames_score" => {
            1 => 0,
            2 => 0,
            3 => 0,
            4 => 0,
            5 => 0,
            6 => 0,
            7 => 0,
            8 => 0,
            9 => 0,
            10 => 0,
          },
          "score_by_frame" => [
            ["F", "F"], ["F", "F"], ["F", "F"],
            ["F", "F"], ["F", "F"], ["F", "F"],
            ["F", "F"], ["F", "F"], ["F", "F"],
            ["F", "F", nil],
          ],
        },
      },
    ]
  end

  def build_regular_player
    [
      {
        "name" => "John",
        "scores" => {
          "frames_score" => {
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
          "score_by_frame" => [
            [3, '/'], [6, 3], ['strike', 'X'], [8, 1], ['strike', 'X'], 
            ['strike', 'X'], [9, 'F'], [7, '/'], ['4', '4'], ['X', 9, 'F'],
          ],
        },
      },
    ]
  end
end
