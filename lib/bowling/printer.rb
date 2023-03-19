module Bowling
  class Printer
    def print_game_result(players_final_scores = nil)
      @players_final_scores = players_final_scores

      display = print_frame_head

      @players_final_scores.each do |player|
        display
          .concat(print_players_name(player))
          .concat(print_pinfalls(player))
          .concat(print_score_display(player))
      end

      display
    end

    private

    def print_frame_head
      "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n"
    end

    def print_players_name(player)
      "#{player["name"]}\n"
    end

    def print_pinfalls(player)
      display = "Pinfalls"

      player.dig("scores", "score_by_frame").each do |frame|
        frame.each do |pinfalls|
          if pinfalls == "strike"
            display << "\t\t"
          elsif pinfalls == nil
            display << "\t-"
          else
            display << "\t#{pinfalls}"
          end
        end
      end

      display + "\n"
    end

    def print_score_display(player)
      display = "Score"

      player.dig("scores", "frames_score").each do |frame, score|
        display << "\t\t#{score}"
      end

      display + "\n"
    end
  end
end
