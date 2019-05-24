# frozen_string_literal: true

require_relative 'execution_strategy'

# Aftermath execution strategy of type Hint that prints and registers hint(s)
class Hint < ExecutionStrategy
  attr_reader :messages, :player

  def initialize(player, messages = [])
    @player = player
    @messages = messages
  end

  def execute
    @messages.each do |message|
      puts "Voice of Zuul: #{message}"
    end
    @player.register_hint messages.join('\n')
  end
end
