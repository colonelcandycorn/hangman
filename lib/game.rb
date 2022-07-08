class Game
  require 'json'
  attr_accessor :word_array

  def initialize
    @word_array = build_word_array
  end

  def build_word_array
    file = File.open('google-10000-english-no-swears.txt')
    file.readlines.map(&:chomp).select do |word|
      word.length >= 5 && word.length <= 12
    end
  end

  def select_random_word
    @word_array[rand(@word_array.length)]
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name
    }.to_json(*args)
  end

  def self.json_create(object) end
end
