# frozen_string_literal: true

require_relative 'execution_strategy'

# Aftermath execution strategy of type Stairway
# that creates a stairway between rooms
class Stairway < ExecutionStrategy
  attr_reader :player, :room

  def initialize(player, room)
    @player = player
    @room = room
  end

  def execute
    @player.current_room.add_room('down', @room)
    @room.add_room('up', @player.current_room)
  end
end
