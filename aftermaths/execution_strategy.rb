# frozen_string_literal: true

# Base exectution strategy class for aftermaths
class ExecutionStrategy
  def execute
    raise 'Must implement'
  end
end
