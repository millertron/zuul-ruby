# frozen_string_literal: true

# Aftermath class that is triggered after a prerequisite is fulfilled
class Aftermath
  attr_reader :execution_strategy

  def initialize(execution_strategy)
    @execution_strategy = execution_strategy
  end

  def execute
    @execution_strategy.execute
  end
end
