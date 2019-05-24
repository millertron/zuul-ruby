# frozen_string_literal: true

# Aftermath execution strategy of type Print that prints message(s)
class Print < ExecutionStrategy
  attr_reader :messages

  def initialize(messages = [])
    @messages = messages
  end

  def execute
    @messages.each { |message| puts message }
  end
end
