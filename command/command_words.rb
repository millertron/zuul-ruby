# frozen_string_literal: true

# Command words that are valid
class CommandWords
  def initialize
    @valid_commands =
      %w[
        go quit help
        observe take drop
        inventory use
        listen talk
      ]
  end

  def valid_command?(command_str)
    @valid_commands.include? command_str
  end

  def formatted_list
    "\n" << @valid_commands.join("\n")
  end
end
