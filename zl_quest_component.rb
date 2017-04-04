class ZlQuestComponent
	attr_reader :id, :type, :room, :item, :player
	
	def initialize id, type, item, room, player
		@id = id
		@type = type
		@item = item
		@room = room
		@player = player
	end
end