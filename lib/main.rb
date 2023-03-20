require_relative 'bowling_game'
require 'pathname'

file_path = ARGV[0] ||= 'scores.txt'
BowlingGame.new(Pathname.getwd.join(file_path)).process_game_file
