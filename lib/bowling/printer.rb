module Bowling
    class Printer
        def initialize(players_final_scores = nil)
            @players_final_scores = players_final_scores
        end

        def print
            print_frame_head.concat(print_players_name)
        end
        
        private

        def print_frame_head
            "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n"
        end

        def print_players_name
            "#{@players_final_scores[0]['name']}"
        end
    end
end