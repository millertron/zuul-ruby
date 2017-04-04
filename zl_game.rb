require_relative 'zl_player'
require_relative 'zl_gnome'
require_relative 'zl_parser'
require_relative 'zl_look_up_table'
require_relative 'zl_room'
require_relative 'zl_quest'
require_relative 'zl_item'
require 'io/console'

class ZlGame
	attr_reader :player, :gnome, :parser, :lut, :quest_queue
	
	def initialize
		@player = ZlPlayer.new
		@gnome = ZlGnome.new
		@quest_queue = Array.new
		@parser = ZlParser.new
		@lut = ZlLookUpTable.new @player
		@lut.quest_catalog[0].activate
		@player.move_to @lut.room_catalog[0]
	end
	
	def play
	
		print_welcome
	
		finished = false
		while !finished
			num_active = @lut.quest_catalog.length
			command = @parser.prompt_command
			finished = process_command command
			
			@lut.quest_catalog.each do |quest|
				quest.check if quest.is_active?
				num_active -= 1 if quest.is_complete?
			end
			
			break if num_active == 0
		end
		
			
		if num_active == 0			
			puts "===== ===== ===== ====="				
			puts "You have completed the game!"
		end

		puts "Press Enter to exit..."
		puts "===== ===== ===== ====="
	
		gets.chomp
		
		puts "Thank you for playing. Good bye."
		
	end
	
	def print_welcome
		puts ""
		puts "The Maze of Zuul"
		puts "A text-based adventure game."
		puts "Type 'help' if you need help."
		puts ""
		puts @player.current_room.long_description
		@player.current_room.visit
	end
	
	def process_command command
		want_to_quit = false
		puts "===== ===== ===== ====="
		if command.is_unknown? then
			puts "I don't know what you mean..."
			return false
		end
		
		case command.command_word
		when "help" then
			print_help
		when "go" then
			go_to_room command
		when "observe" then
			puts @player.current_room.long_description
		when "take" then
			take_item command
		when "drop" then
			drop_item command
		when "inventory" then
			print_inventory
		when "use" then
			use_item command
		when "listen" then
			listen_for_hint
		when "talk" then
			talk_to_gnome
		when "quit"
			want_to_quit = quit command
		end
		
		want_to_quit
	end
	
	def print_help
		puts "You are lost. You are alone. You must explore the area to find a path to complete your journey."
		puts ""
		puts "You command words are: #{@parser.show_commands}"
	end
	
	def go_to_room command
		if command.second_word == nil then
			puts "Go where? (#{@player.current_room.exit_string})"
			return
		end
		next_room = nil
		direction = (command.second_word == "back" ? @player.reverse_direction : command.second_word)
		
		next_room = @player.current_room.exit_in_direction direction
		@player.move_in_direction direction

		if next_room == nil then
			puts "There is no door!"
		else
			@player.move_to next_room
			if next_room.has_been_visited?
				puts next_room.short_description
			else
				puts next_room.long_description
				next_room.visit
			end
		end
	end
	
	def take_item command
		item_name = command.second_word
		if item_name == nil then
			puts "Take what?"
			return
		end
		
		if @player.current_room.has_item? item_name then
			item_to_take = @player.current_room.fetch_item item_name
			if !item_to_take.is_portable? then
				puts "The item cannot be carried."
				return
			end
			if @player.weight + item_to_take.weight > @player.max_weight then
				puts "Your inventory is too heavy."
				return
			end
			@player.current_room.check_item_out item_name
			@player.add_to_inventory item_to_take
			puts "#{item_name} added to inventory."
		else 
			puts "The item is not here."
		end
	end
	
	def drop_item command
		item_name = command.second_word
		if item_name == nil then
			puts "Drop what?"
			return
		end
		
		@player.inventory.each do |item|
			if item_name == item.name then
				@player.remove_from_inventory item
				@player.current_room.add_item item
				item.place_in_location "on the floor"
				puts "#{item_name} dropped on the floor."
				return
			end
		end
		puts "You don't have #{item_name} in your inventory."
	end
	
	def print_inventory
		puts "INVENTORY - weight: #{@player.weight} / #{@player.max_weight}"
		if @player.inventory.length == 0 then
			puts "Your inventory is currently empty."
			puts "Use the take command to pick up items from a room."
		else
			@player.inventory.each do |item|
				puts "#{item.name} : #{item.description}"
			end
		end
	end
	
	def expend_item item
		item.take_effect
		if item.charge == 0 then
			if @player.has_item? item.name then
				@player.remove_from_inventory item
			else
				@player.current_room.check_item_out item.name
			end
		end
	end
	
	def use_item command
		item_name_one = command.second_word
		if item_name_one == nil then
			puts "Use what?"
			return
		end
		item_one = @player.fetch_item item_name_one
		if item_one == nil then
			item_one = @player.current_room.fetch_item item_name_one
			if item_one == nil then
				puts "The item isn't there."
				return
			end
		end
		if command.third_word == nil then
			if item_one.type == "gnome" && @player.current_room.is_gnome_present? then
				puts @gnome.scream
				@player.current_room.gnomify false
				expend_item item_one
				return
			elsif item_one.type == "self" then
				puts "You used #{item_name_one}."
				expend_item item_one
				return
			else
				puts "Use #{item_name_one} on what?"
				return
			end
		end
		
		item_target_name = command.fourth_word
		if command.third_word != "on" || (command.third_word == "on" && item_target_name == nil) then
			puts "Incorrect command usage. Try 'use A' or 'use A on B'."
			return		
		end
		
		item_target = @player.current_room.fetch_item item_target_name
		if item_target == nil then
			puts "The target item isn't there."
			return
		elsif !item_target.is_compatible_with? item_one then
			puts "Nothing happens."
			return
		elsif @player.current_room.is_gnome_present? then
				puts "The gnome gets in your way."
				puts "Gnome: Nyeh-heh-heh-heh-heh!"
				return
		end
		expend_item item_one
		item_target.evolve
		
	end
	
	def listen_for_hint
		if @player.hint != nil then
			puts "Voice of Zuul: #{@player.hint}"
		else
			puts "you hear nothing..."
		end
	end
	
	def talk_to_gnome
		if @player.current_room.is_gnome_present? then
			puts @gnome.retort
		else
			puts "There's no-one to talk to."
		end
	end
	
	def quit command
		if command.second_word != nil then
			puts "Quit what?"
			return false
		end
		true
	end
	
end

ZlGame.new.play