require_relative 'bowling_game'
require 'pathname'
require 'pry-byebug'

file_path = ARGV[0] ||= Pathname.getwd.join('data').join('scores.txt')
BowlingGame.new(
  Pathname.getwd.join(file_path)
).process_game_file
