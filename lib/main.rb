require_relative 'bowling_game'
require 'pathname'

BowlingGame.new(Pathname.getwd.join('scores.txt')).process_game_file
