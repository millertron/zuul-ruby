class ZlCommandWords

	def initialize
		@valid_commands =
		[
			"go", "quit", "help", 
			"observe", "take", "drop",
			"inventory", "use",
			"listen", "talk"
		]
	end
	
	def is_valid_command? command_str
		@valid_commands.include? command_str
	end
	
	def print_all
		str = "\n"
		@valid_commands.map{ |command| str << command << "\n" }
		str
	end

end