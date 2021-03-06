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
  puts "game saved, should be here for you when you come back!"
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


def game_turn(game)
  until game.count == 0 || game.hint == game.word
    puts "Here is your hint:"
    game.show_hint
    user_input = game.get_input
    game.guess(user_input)
    puts "You have #{game.count-1} misses left"
  end
end

def end_game(game)
  if game.count == 0
    puts "sorry, you hanged, man"
    puts "the word was #{game.word.join('')}"
  else
    puts "nice, you got it!"
    puts "the word was #{game.word.join('')}"
  end
end


########## game flow ###########

puts "Welcome to Hangman"


choice = 0
until choice == 1 || choice == 2
  puts "Please select a choice"
  puts "1) New Game \n2) Load Game"
  choice = gets.chomp.to_i
end

if choice == 1

  game = Game.new
  game_turn(game)
  end_game(game)

elsif choice == 2

  chosen_game = -1
  until chosen_game > -1 && chosen_game < (list_saved_games.length + 1)
    puts "please choose a game"
    list_saved_games
    chosen_game = gets.chomp.to_i
  end
  chosen_game_string = list_saved_games[chosen_game-1]

  game = load_game(chosen_game_string)

  puts "nice, you loaded a game"
  puts "You have #{game.count-1} misses left"

  game_turn(game)
  end_game(game)

end
