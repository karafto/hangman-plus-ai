require './game'
require './board'
require './human_player'
require './ai_player'
require 'json'

class Hangman
  def initialize(min_word_length, max_word_length)
    puts "\nWelcome to HANGMAN!"
    word_list = File.readlines('dictionary.txt').map { |entry| entry.strip }
    @eligible_words = word_list.select do |word|
      word.length >= min_word_length && word.length <= max_word_length
    end
  end

  def master_loop
    loop do
      choose_player
      choose_game
      game = Game.new(@resume, @human, @eligible_words)
      game.play_game
      File.delete('saved_game.json') if @resume
    end
  end

  def choose_player
    loop do
      puts "\nWould you like to play as a (h)uman or (n)onhuman AI? You can also (q)uit. (h/n/q):"
      @choice = gets.strip.downcase
      break if @choice == 'h' || @choice == 'n' || @choice == 'q'
    end
    exit if @choice == 'q'
    @choice == 'h' ? @human = true : @human = false
  end

  def choose_game
    @resume = false
    if @human && File.exist?('saved_game.json')
      loop do
        puts "\nWould you like to (r)esume your saved game, or start a (n)ew one? (r/n):"
        @choice = gets.strip.downcase
        break if @choice == 'r' || @choice == 'n'
      end
      @choice == 'r' ? @resume = true : @resume = false
    end
  end
end

min_word_length = 5
max_word_length = 12
hangman = Hangman.new(min_word_length, max_word_length)
hangman.master_loop