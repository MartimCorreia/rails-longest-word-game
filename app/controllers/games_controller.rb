require 'json'
require 'open-uri'
class GamesController < ApplicationController
  def new
    @vowels = ['A', 'E', 'I', 'O', 'U']
    @grid = (0...8).map { (65 + rand(26)).chr }
    @generated_numbers = 2.times.map { Random.rand(4) }
    @grid << @vowels[@generated_numbers[0]]
    @grid << @vowels[@generated_numbers[1]]
    @game_grid = "#{@grid[0]} #{@grid[1]} #{@grid[2]} #{@grid[3]} #{@grid[4]} #{@grid[5]} #{@grid[6]} #{@grid[7]}"
    @game_grid += " #{@grid[8]} #{@grid[9]}"
  end

  def score
    @answer = ''
    @word = params[:answer]
    if can_form?(@word)
      case @word
        when dictionary?(@word)
          @answer = "Congratulations! #{@word.upcase} is a valid English word"
        else
          @answer = "#{@word.upcase} not an english word"
      end
    else
      @answer = "Sorry but #{@word.upcase} can't be built out of #{params[:grid]}"
    end
  end

  def can_form?(word)
    # @valid_word = ''
    # word_to_array = word.chars
    # @upcase_array = word_to_array.map { |letter| letter.upcase }
    @word.chars.each do |letter|
      @valid = params[:grid].include?(letter)
     end
  end



  def dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    dictionary = JSON.parse(user_serialized)
    dictionary['found']
  end
end
