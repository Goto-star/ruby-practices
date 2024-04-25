# frozen_string_literal: true

require_relative 'game'

mark = ARGV[0]
marks = mark.split(',')

game = Game.new(marks)
puts game.score
