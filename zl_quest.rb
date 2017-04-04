require_relative 'zl_player'
require_relative 'zl_condition'
require_relative 'zl_aftermath'
require_relative 'zl_room'
require_relative 'zl_item'

class ZlQuest

	attr_reader :name, :conditions, :aftermaths, :active, :complete, :next, :player

	def initialize name, player
		@name = name
		@player = player
		@conditions = Array.new
		@aftermaths = Array.new
		@active = false
		@complete = false
	end

	def add_condition id, type, item, room
		condition = ZlCondition.new id, type, item, room, @player
		@conditions << condition
	end
	
	def add_aftermath id, type, item, room, messages
		aftermath = ZlAftermath.new id, type, item, room, messages, @player
		@aftermaths << aftermath
	end
	
	
	def check
		@conditions.each do |condition|
			return if !condition.is_fulfilled?
		end
		@aftermaths.map(&:execute)
		if (@next) then @next.activate end
		mark_complete
	end
	
	def activate
		@active = true
	end
	
	def is_active?
		@active
	end
	
	def is_complete?
		@complete
	end
	
	def deactivate
		@active = false
	end
	
	def mark_complete
		@complete = true
		@active = false
	end
	
	def set_next next_quest
		@next = next_quest
	end
	
end