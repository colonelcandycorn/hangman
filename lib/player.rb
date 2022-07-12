class Player
  attr_accessor :name, :guesses

  def initialize(name)
    @name = name
    @guesses = []
  end

  def take_a_guess
    puts "Please take a guess, #{@name}"
    guess = gets.chomp.downcase.delete('^a-z')[0]
    return take_a_guess if guess.empty? || @guesses.include?(guess)

    return 'save' if guess == 'save'

    @guesses.push(guess)
    guess
  end
end
