# frozen_string_literal: true

require_relative 'command_words'
require_relative 'command'

# Class to parse user input to instantiate commands
class CommandParser
  def initialize
    @commands = CommandWords.new
  end

  def prompt_command
    print '> '
    input = gets.chomp
    parse_command input.to_s
  end

  def parse_command(command_str)
    words = command_str.strip.split(' ')
    words[0] = nil if words[0].nil? || !@commands.is_valid_command?(words[0])

    Command.new(words)
  end

  def show_commands
    @commands.print_all
  end
end
