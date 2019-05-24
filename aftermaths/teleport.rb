# frozen_string_literal: true

require_relative 'execution_strategy'

# Aftermath execution strategy of type Teleport that transports player to a room
class Teleport < ExecutionStrategy
  attr_reader :player, :room

  def initialize(player, room)
    @player = player
    @room = room
  end

  def execute
    puts 'You were teleported!'
    @player.move_to @room
  end
end
