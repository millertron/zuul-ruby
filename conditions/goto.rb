# frozen_string_literal: true

require_relative 'condition'

# Goto-type condition
class Goto < Condition
  attr_reader :room

  def initialize(room)
    @room = room
  end

  def fulfilled?
    @room.been_visited?
  end
end
