# frozen_string_literal: true

# Base condition (strategy) for prerequisite to trigger aftermaths
class Condition
  def fulfilled?
    raise 'Must implement'
  end
end
