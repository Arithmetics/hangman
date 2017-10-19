#hangman game
require 'yaml'


class Game
  attr_accessor :word, :count, :hint, :available_letters

  def initialize
    @word = new_word.split('')
    @count = 6
    @hint = []
    @word.length.times { @hint << "_"}
    @available_letters = ("a".."z").to_a
  end

  def new_word
    dictionary = File.readlines('5desk.txt')
    word = dictionary.sample.chomp
    until word.length < 13 && word.length > 4
      word = dictionary.sample.chomp
    end
    word
  end

  def guess(letter)
    @available_letters -= [letter]
    correct = false
    @word.each_with_index do |x,i|
      if x == letter
        @hint[i] = letter
        correct = true
      end
    end
    if !correct
      @count -= 1
    end
  end

  def show_hint
    puts @hint.join(" ")
  end

  def show_available_letters
    puts @available_letters.join(",")
  end

  def get_input
    input = ""
    until input.length == 1 && self.available_letters.any? { |x| x == input  }
      puts "please pick from these letters, or press 1 to save your game"
      self.show_available_letters
      input = gets.chomp.to_s
      if input.to_i == 1
        puts "what should we name your game?"
        saved = gets.chomp.to_s
        save_game(self, saved)
        exit
      end
    end
    input
  end

end

def save_game(game, name)
  File.open("saved_games/#{name}.yaml", "w") do |file|
    file.puts YAML::dump(game)
  end
end

def load_game(name)
  array = []
  $/="\n\n"
  File.open("saved_games/#{name}.yaml", "r").each do |object|
    array << YAML::load(object)
  end
  array[0]
end

def list_saved_games
  games = Dir["./saved_games/*.yaml"]
  games.map! { |x| x.scan(/(?<=saved_games\/)(.*)(?=\.yaml)/)  }
  games.flatten!
  games.each_with_index {|x,i| puts "#{i+1}) #{x} \n"}
end
