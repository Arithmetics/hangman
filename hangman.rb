#hangman game

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




end



########## game flow #######33####
game = Game.new
puts "Welcome to Hangman"

until game.count == 0 || game.hint == game.word

  puts "Here is your hint:"
  game.show_hint

  puts "please pick from these letters"
  game.show_available_letters
  input = gets.chomp.to_s

  until input.length == 1 && game.available_letters.any? { |x| x == input  }
    puts "please pick from these letters"
    game.show_available_letters
    input = gets.chomp.to_s
  end

  game.guess(input)

  puts "You have #{game.count-1} misses left"


end


if game.count == 0
  puts "sorry, you hanged, man"
  puts "the word was #{game.word.join('')}"
else
  puts "nice, you got it!"
  puts "the word was #{game.word.join('')}"
end
