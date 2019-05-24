# frozen_string_literal: true

# Class instantiating a command
class Command
  attr_reader :words

  def initialize(command_words)
    @words = Array.new(4)
    (0...4).each do |i|
      @words[i] = command_words[i] if command_words[i]
    end
  end

  def command_word
    @words[0]
  end

  def second_word
    @words[1]
  end

  def third_word
    @words[2]
  end

  def fourth_word
    @words[3]
  end

  def unknown?
    @words[0].nil?
  end
end
