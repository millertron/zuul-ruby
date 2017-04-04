require_relative 'zl_item'
class ZlPlayer
	attr_reader :weight, :max_weight,
				:hint, :direction, :inventory, :current_room

	def initialize
		@weight = 0
		@max_weight = 5
		@inventory = Array.new
	end
	
	def reverse_direction
		case @direction
		when "north"
			"south"
		when "south"
			"north"
		when "east"
			"west"
		when "west"
			"east"
		when "up"
			"down"
		when "down"
			"up"
		else 
			nil
		end
	end
	
	
	def has_item? item_name
		@inventory.each do |item|
			item.name == item_name
			return true
		end
		false
	end
	
	def fetch_item item_name
		@inventory.each do |item|
			if item.name == item_name then
				return item
			end
		end
		nil
	end
	
	def add_to_inventory item
		@inventory << item
		@weight += item.weight
	end
	
	def remove_from_inventory item
		@inventory.each_with_index do |i, index|
			if i.name == item.name then
				@inventory.delete_at(index)
				break
			end
		end
		@weight -= item.weight
	end
	
	def register_hint hint
		@hint = hint
	end
	
	def move_in_direction direction
		@direction = direction
	end
	
	def move_to target_room
		@current_room = target_room
	end
	
end