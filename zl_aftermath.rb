require_relative 'zl_quest_component'
require_relative 'zl_player'
require_relative 'zl_room'
require_relative 'zl_item'

class ZlAftermath < ZlQuestComponent
	def initialize id, type, item, room, messages, player
		super(id, type, item, room, player)
		@messages = (messages != nil ? messages : Array.new)
	end

	
	def execute
		case type
		when "print" then
			@messages.each do |message|
				puts message
			end
		when "hint" then
			hint = String.new
			@messages.each do |message|
				hint << message
				puts "Voice of Zuul: " << message
			end
			@player.register_hint hint
		when "stairway" then
			@player.current_room.add_room "down", @room
			@room.add_room "up", @player.current_room
		when "teleport" then
			puts "You were teleported!"
			@player.move_to @room
		end
	end
end