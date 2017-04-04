require_relative 'zl_command_words'
require_relative 'zl_command'

class ZlParser
	def initialize
		@commands = ZlCommandWords.new
	end

	def prompt_command
		print "> "
		input = gets.chomp
		parse_command input.to_s
	end
	
	def parse_command command_str
		words = command_str.strip.split(" ")
		if (words[0] == nil || !@commands.is_valid_command?(words[0]) ) then
			words[0] = nil
		end
		
		ZlCommand.new(words)
	end
	
	def show_commands
		@commands.print_all
	end
end