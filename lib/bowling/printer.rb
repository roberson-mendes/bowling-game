require "pry-byebug"

module Bowling
  class Printer
    def initialize(players_final_scores = nil)
      @players_final_scores = players_final_scores
    end

    def print
      print_frame_head
        .concat(print_players_name)
        .concat(print_pinfalls)
        .concat(print_score_display)
    end

    private

    def print_frame_head
      "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\n"
    end

    def print_players_name
      "#{@players_final_scores[0]["name"]}\n"
    end

    def print_pinfalls
      display = "Pinfalls"

      @players_final_scores.each do |player|
        player.dig("scores", "score_by_frame").each do |frame|
          frame.each do |pinfalls|
            if pinfalls == "strike"
              display << "\t\t"
            else
              display << "\t#{pinfalls}" unless pinfalls == nil
            end
          end
        end
      end

      display + "\n"
    end

    def print_score_display
      display = "Score"

      @players_final_scores.each do |player|
        player.dig("scores", "frames_score").each do |frame, score|
          display << "\t\t#{score}"
        end
      end

      display + "\n"
    end
  end
end
