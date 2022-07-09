class Game
  require 'json'
  attr_accessor :word_array, :current_word, :guess_array, :num_of_guesses, :incorrect_guesses

  def initialize
    @word_array = build_word_array
    @guess_array = []
    @num_of_guesses = 0
    @incorrect_guesses = []
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
    @num_of_guesses += 1
    return incorrect_guess(guess) unless @current_word.include?(guess)

    @current_word.split('').each_with_index do |letter, index|
      @guess_array[index] = letter if guess == letter
    end
  end

  def incorrect_guess(guess)
    @incorrect_guesses.push(guess)
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name
    }.to_json(*args)
  end

  def self.json_create(object) end
end


game = Game.new
game.select_random_word
game.build_guess_array
p game.current_word
p game.guess_array
p game.compare_guess_to_word('a')
p game.guess_array
p game.incorrect_guesses