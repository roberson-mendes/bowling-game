require 'spec_helper'
require 'bowling_game'
require 'scores_builder'
require 'bowling/validator/invalid_input_exception'
require 'bowling/input_validator'
require 'bowling/file_processor'
require 'bowling/bowling_score_calculator'
require 'bowling/printer'

RSpec.describe BowlingGame do
  let(:perfect) { file_fixture('perfect.txt') }
  let(:scores) { file_fixture('scores.txt') }
  let(:regular) { file_fixture('regular.txt') }
  let(:free_text) { file_fixture('free-text.txt') }
  let(:fouls) { file_fixture('fouls.txt') }
  let(:three) { file_fixture('three.txt') }

  context 'when starts the game' do 
    it 'process the file' do
      file_processor = spy(Bowling::FileProcessor)
      bowling_score_calculator = class_double(Bowling::BowlingScoreCalculator)
      bowling_score_instance = instance_double(Bowling::BowlingScoreCalculator)
      printer = instance_double(Bowling::Printer)
      allow(bowling_score_calculator).to receive(:new)
        .and_return(bowling_score_instance)
      allow(bowling_score_instance).to receive(:calculate)
        .with(anything)
  
      subject = described_class.new(
        perfect, 
        file_processor: file_processor,
        bowling_score_calculator: bowling_score_calculator
      ).process_game_file
      
      expect(file_processor).to have_received(:get_players_scores)
    end
  end
  
  context 'when starts the program' do
    it 'calculates the game rules for one player' do
      scores_builder = spy(ScoresBuilder)
      player_scores = {
        "Carl" => ["10", "10", "10", "10", "10", "10", "10", "10", "10","10",
                   "10", "10"]
      }
      printer = instance_double(Bowling::Printer)
      allow(printer).to receive(:print_game_result).with(anything)

      subject = described_class.new(
        perfect,
        scores_builder: scores_builder,
        printer: printer
      ).process_game_file
      
      expect(scores_builder).to have_received(:build_players_scores)
    end

    it 'prints the game results' do
      printer = spy(Bowling::Printer)

      subject = described_class.new(
        perfect,
        printer: printer
      ).process_game_file
      
      expect(printer).to have_received(:print_game_result)
        .with(perfect_player)
    end

    it 'prints the game score correctly' do
      expected_display = header_display + regular_player_display

      subject = described_class.new(
        regular
      )

      expect { subject.process_game_file }.to output(expected_display).to_stdout
    end

    context 'when input file is valid' do
      context 'with one player' do
        context 'and game rules are valid' do
          context 'with strikes in all throwings' do
            it 'prints a perfect game scoreboard' do
              expected_display = header_display + perfect_display
      
              subject = described_class.new(
                perfect
              )
        
              expect { subject.process_game_file }.to output(expected_display).to_stdout
            end
          end
          
          context 'with fouls in all throwings' do
            it 'prints the game scoreboard to stdout' do
              expected_display = header_display + fouls_display
      
              subject = described_class.new(
                fouls
              )
        
              expect { subject.process_game_file }.to output(expected_display).to_stdout
            end
          end
        end
      end

      context 'with more than two players' do
        it 'prints the game scoreboard to stdout' do
          expected_display = header_display + jeff_display + john_display +
                             robi_display
      
          subject = described_class.new(
            three
          )
    
          expect { subject.process_game_file }.to output(expected_display).to_stdout
        end
      end
    end
  end

  private
  
  def perfect_player
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

  def header_display
    "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n"
  end

  def regular_player_display
    "John\n" +
    "Pinfalls\t3\t/\t6\t3\t\t\tX\t8\t1\t\t\tX\t\t\tX\t9\tF\t7\t/\t4" +
      "\t4\tX\t8\t/\n" + 
    "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t" +
      "132\t\t152\n"
  end

  def perfect_display
    "Carl\n" +
    "Pinfalls\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX\t\t\tX" +
      "\t\t\tX\tX\tX\tX\n" +
    "Score\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t" +
      "270\t\t300\n"
  end

  def fouls_display
    "Carl\n" +
    "Pinfalls\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\t" +
      "F\tF\t-\n" +
    "Score\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\n"
  end

  def john_display
    "John\n" +
    "Pinfalls\t3\t/\t6\t3\t\t\tX\t8\t1\t\t\tX\t\t\tX\t9\tF\t7\t/\t4" +
      "\t4\tX\t9\tF\n" +
    "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t" +
      "132\t\t151\n"
  end

  def jeff_display
    "Jeff\n" +
    "Pinfalls\t\t\tX\t7\t/\t9\tF\t\t\tX\tF\t8\t8\t/\tF\t6\t\t\tX\t\t" +
      "\tX\tX\t8\t1\n" +
    "Score\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t" +
      "148\t\t167\n"
  end

  def robi_display
    "Robi\n" +
    "Pinfalls\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\t" +
      "F\tF\t-\n" +
    "Score\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\n"
  end
end
