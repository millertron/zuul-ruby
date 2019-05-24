# frozen_string_literal: true

require_relative 'condition'

# configure-type condition that checks if an item has updated its status
class Configure < Condition
  attr_reader :item

  def initialize(item)
    @item = item
  end

  def fulfilled?
    @item.evolved?
  end
end
