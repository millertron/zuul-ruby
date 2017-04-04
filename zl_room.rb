require_relative 'zl_item'

class ZlRoom
	attr_reader :id, :name, :description, :visited, :exits, :items,
				:gnome_present
				
	def initialize id, name, description
		@id = id
		@name = name
		@description = description
		@items = Array.new
		@exits = Hash.new
		@visited = false
		@gnome_present = false
	end
	
	def short_description
		str = String.new << @description << "\n"
		if @items.any? then
			str << "Items: " 
		end
		@items.map { |item| str << item.short_description << " "}
		str << "\n"
		if is_gnome_present? then 
			str << "Gnome!\n" 
		end
		str << exit_string
		str
	end
	
	def long_description
		str = "You are in " << @description << ".\n"
		if @items.any? then
			if @items.length > 1 then
				str << "There are:\n"
			else 
				str << "There is "
			end
			@items.map { |item| str << item.long_description + ".\n"}
		end
		if is_gnome_present? then
			str << "Also there's a gnome. \n" 
		end
		str << exit_string
		str		
	end
	
	def is_gnome_present?
		@gnome_present
	end
	
	def exit_string
		str = String.new << "Exits: "
		@exits.map { |k, v| str << k << " " }
		str
	end
	
	def exit_in_direction direction
		@exits[direction]
	end
	
	def add_item item
		@items << item
	end
	
	def check_item_out item_name
		@items.each_with_index do |item, index| 
			if item.name == item_name 
				@items.delete_at(index)
				#only remove first occurrence
				return
			end
		end
	end
	
	def has_item?(item)
		has_item?(item.name)
	end
	
	def has_item?(item_name)
		number_of_items(item_name) > 0
	end
	
	def number_of_items(item_name)
		num = 0
		@items.each do |item|
			if item.name == item_name
				num += 1
			end
		end
		num
	end
	
	def fetch_item item_name
		@items.each do |item|
			if item.name == item_name then
				return item
			end
		end
		nil
	end
	
	def gnomify gnome_present
		@gnome_present = gnome_present
	end
	def visit
		@visited = true
	end
	
	def has_been_visited?
		@visited
	end
	
	def add_room direction, room
		@exits[direction] = room
	end
end