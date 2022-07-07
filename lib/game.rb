words = File.open('google-10000-english-no-swears.txt')

class Game
  require 'json'

  def initialize() end

  def build_word_array(file)
    file.readlines.map(&:chomp).select do |word|
      word.length >= 5 && word.length <= 12
    end
  end

  def to_json(*args)
    {
      JSON.create_id => self.class.name
    }.to_json(*args)
  end

  def self.json_create(object)
    new(*object[])
  end
end
