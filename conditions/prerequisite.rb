# frozen_string_literal: true

require_relative 'condition'

# Prerequisite class checks for conditions to trigger aftermaths
class Prerequisite
  attr_reader :condition

  def initialize(condition)
    @condition = condition
  end

  def fulfilled?
    @condition.fulfilled?
  end
end
