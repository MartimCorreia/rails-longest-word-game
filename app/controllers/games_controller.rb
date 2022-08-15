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
    if can_form?(@word) && dictionary?(@word)
      @answer = "Congratulations! #{@word.upcase} is a valid English word"
    elsif !dictionary?(@word)
      @answer = "#{@word.upcase} not an english word"
    else
      @answer = "Sorry but #{@word.upcase} can't be built out of #{params[:grid]}"
    end
  end

  def can_form?(word)
    @valid_word = false
    @counter = 0
    word.chars.each do |letter|
      @counter += 1 if params[:grid].include?(letter.upcase) == true
      @valid_word = true if @counter == word.size
    end
    @valid_word
  end

  def dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    user_serialized = URI.open(url).read
    dictionary = JSON.parse(user_serialized)
    dictionary['found']
  end
end
