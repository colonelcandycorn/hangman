class Game
  require 'json'
  require_relative './player'

  attr_accessor :word_array, :current_word, :guess_array, :num_of_guesses, :incorrect_guesses, :player

  def initialize(name = '')
    @word_array = build_word_array
    @guess_array = []
    @num_of_guesses = 0
    @incorrect_guesses = []
    @player = create_player(name)
  end

  def create_player(name)
    return Player.new(name) unless name.empty?

    puts 'Please enter your name'
    new_name = gets.chomp.delete('^a-zA-Z')
    return create_player if new_name.empty?

    Player.new(new_name)
  end

  def build_word_array
    file = File.open('google-10000-english-no-swears.txt')
    file.readlines.map(&:chomp).select do |word|
      word.length >= 5 && word.length <= 12
    end
  end

  def select_random_word
    @current_word = @word_array[rand(@word_array.length)]
  end

  def build_guess_array
    return unless guess_array.empty?

    @current_word.length.times { @guess_array.push('_') }
  end

  def compare_guess_to_word(guess)
    return save_game if guess == 'save'

    return incorrect_guess(guess) unless @current_word.include?(guess)

    @current_word.split('').each_with_index do |letter, index|
      @guess_array[index] = letter if guess == letter
    end
  end

  def incorrect_guess(guess)
    unless @incorrect_guesses.include?(guess)
      @incorrect_guesses.push(guess)
      @num_of_guesses += 1
    end
  end

  def check_winner
    guess_array.join('') == @current_word
  end

  def play_game
    select_random_word unless @current_word
    build_guess_array

    while @num_of_guesses < 12 && !check_winner
      puts @guess_array.join(' ')
      puts "Incorrect Guesses: #{@incorrect_guesses.join(', ')}"
      puts "Remaining Guesses: #{12 - @num_of_guesses}"
      compare_guess_to_word(@player.take_a_guess)
    end

    puts 'Congrats you guessed the word' if check_winner
    puts "You failed to guess the word: #{@current_word}" if @num_of_guesses == 12 && !check_winner
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name,
      'guess_array' => @guess_array,
      'incorrect_guesses' => @incorrect_guesses,
      'num_of_guesses' => @num_of_guesses,
      'player' => @player.name,
      'player_guesses' => @player.guesses,
      'current_word' => @current_word
    }.to_json(*args)
  end

  def self.json_create(object)
    game = new(object['player'])
    game.guess_array = object['guess_array']
    game.incorrect_guesses = object['incorrect_guesses']
    game.num_of_guesses = object['num_of_guesses']
    game.current_word = object['current_word']
    game.player.guesses = object['player_guesses']
    game
  end

  def save_game
    save = JSON.generate(self)
    name = "#{@player.name}#{guess_array.join('')}"
    path = File.expand_path('~/hangman/files')
    Dir.mkdir(path) unless Dir.exist?(path)
    File.open(path + "/#{name}.txt", 'w') { |f| f.write save }
  end

  def self.list_saves
    path = File.expand_path('~/hangman/files/*')
    saves = Dir[path]
    saves.each_with_index do |file, index|
      puts "[#{index}] #{file}\n"
    end
    saves
  end

  def self.choose_save_to_load(saves)
    choice = gets.chomp.delete('^\d')[0]
    saves[choice]
  end

  def self.load_game(file)
    save = File.readlines(file)
    JSON.parse(save[0], create_additions: true)
  end
end

game = Game.new
game.list_saves
game.play_game
# game.select_random_word
# game.build_guess_array
# game.compare_guess_to_word('a')
# p game.current_word
# p game.guess_array
# json = JSON.generate(game)
# obj = JSON.parse(json, create_additions: true)
# p json
# p obj.player.name
