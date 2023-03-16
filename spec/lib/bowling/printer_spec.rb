require 'bowling/printer'

RSpec.describe Bowling::Printer do
    context 'when prints a valid input' do
        context 'with one player' do
            it 'prints frames head on first line' do
                frames_head = "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8" +
                    "\t\t9\t\t10\n"
                players_final_scores = [
                    {
                        'name' => 'Carl',
                        'pinfalls' => ["X", "7", "3", "9", "F", "x", "f", "8",
                            "8", "2", "0", "6", "10", "10","10", "8", "1"],
                        'frames_scores' => {
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
                        }
                    }
                ]

                subject = described_class.new(players_final_scores).print

                
                expect(get_head(subject)).to eq(frames_head)
            end
    
            it 'prints players name on second line' do
                player_name = "Carl"
                players_final_scores = [
                    {
                        'name' => 'Carl',
                        'pinfalls' => ["X", "7", "3", "9", "F", "x", "f", "8",
                            "8", "2", "0", "6", "10", "10","10", "8", "1"],
                        'frames_scores' => {
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
                        }
                    }
                ]

                subject = described_class.new(players_final_scores).print

                
                expect(get_name(subject)).to eq(player_name)
            end
            
            xit 'prints pinfalls on third line' do
    
            end
    
            xit 'prints pinfalls on third line' do
    
            end
    
            xit 'prints frame score on third line' do 
            end
    
            xit 'formats the output to show "X" on strikes' do
            end
    
            xit 'formats the output to show "\" on spares' do
            end
    
            xit 'formats the output to show "F" on fouls' do
            end
        end

        context 'with two or more players' do
            xit 'prints the expected scores' do
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
end