require_relative 'zl_quest_component'
require_relative 'zl_room'
require_relative 'zl_item'

class ZlCondition < ZlQuestComponent
	def is_fulfilled?
		case type
		when "configure" then
			@item.has_evolved?
		when "place_item" then
			@room.items.include? @item
		when "goto" then
			@room.has_been_visited?
		else 
			false
		end
	end
end