require_relative './player'
require_relative './game'

game_state = true

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

  return true unless choice == '2'

  false
end

puts 'Welcome to Hangman'
while game_state
  game = create_game
  game.play_game
  game_state = play_again?
end
