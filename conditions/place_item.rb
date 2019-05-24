# frozen_string_literal: true

require 'condition'

# Place-item-type condition checks if a room contains an item
class PlaceItem < Condition
  attr_reader :room, :item

  def initialize(room, item)
    @room = room
    @item = item
  end

  def fulfilled?
    @room.items.include? @item
  end
end
