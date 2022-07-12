class Player
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def take_a_guess
    guess = gets.chomp.downcase.delete('^a-z')
    return 'save' if guess == 'save'

    guess[0]
  end
end
