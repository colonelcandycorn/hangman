class Player
  attr_accessor :name, :guesses

  def initialize(name)
    @name = name
    @guesses = []
  end

  def take_a_guess
    puts "Please take a guess, #{@name}"
    guess = gets.chomp.downcase.delete('^a-z')
    if guess.empty? || @guesses.include?(guess)
      puts "You've already chosen that letter before silly"
      return take_a_guess
    end

    return 'save' if guess == 'save'

    @guesses.push(guess)[0]
    guess[0]
  end

  def self.choose_save_to_load(saves)
    return nil unless saves

    choice = gets.chomp.delete('^0-9')[0]
    saves[choice.to_i]
  end

  def self.new_or_load_game
    choice = gets.chomp.delete('^0-9')[0]

    return new_or_load_game unless '12'.include?(choice)

    choice
  end
end
