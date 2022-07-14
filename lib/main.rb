require_relative './player'
require_relative './game'

def create_game
  puts '[1] New Game'
  puts '[2] Load Game'
  choice = Player.new_or_load_game
  return Game.new unless choice == '2'

  file = Player.choose_save_to_load(Game.list_saves)
  unless file
    puts 'No Saves to Load'
    return create_game
  end
  Game.load_game(file)
end

def play_again?
  puts '[1] Play Again'
  puts '[2] End game'
  choice = Player.new_or_load_game

  return create_game unless choice == '2'
end

puts 'Welcome to Hangman'
game = create_game
game.play_game
play_again?
