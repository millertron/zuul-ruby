require_relative 'zl_player'
require_relative 'zl_room'
require_relative 'zl_quest'
require_relative 'zl_condition'
require_relative 'zl_aftermath'
require_relative 'zl_item'

class ZlLookUpTable
	attr_reader :item_catalog, :room_catalog, :quest_catalog, :player
	
	def initialize player
		@player = player
		@item_catalog = Array.new
		@room_catalog = Array.new
		@quest_catalog = Array.new
	
		#Prologue
	
		coke = ZlItem.new "coke", "a can of COKE", nil, "self", true, 1, 1,
			"You feel refreshed!"
		chair = ZlItem.new "chair", "a round CHAIR", nil, "self", false, 0, -1,
			"You took a short rest"
		notice_board = ZlItem.new "noticeboard", "a school NOTICEBOARD", nil, "self", 
			false, 0, -1,
			"The noticeboard says 'Go to Course Admin Office to hand in assignments'."
		vending_machine = ZlItem.new "vendingmachine", "a VENDINGMACHINE", nil, "self",
			false, 0, -1,
			"You forgot to bring money."
			
		outside = ZlRoom.new 1, "Cornwalis Front", "the computing lobby"
		theatre = ZlRoom.new 2, "Lecture Room 1", "a lecture theatre"
		pub = ZlRoom.new 3, "Campus Pub", "the campus pub"
		lab = ZlRoom.new 4, "Computing Lab 1", "a computing lab"
		office = ZlRoom.new 5, "Course Admin Office", "the computing admin office"
		a1 = ZlRoom.new 6, "Small room", "a small dull room"
		
		outside.add_room "east", theatre
		outside.add_room "south", lab
		outside.add_room "west", pub
		theatre.add_room "west", outside
		pub.add_room "east", outside
		lab.add_room "north", outside
		lab.add_room "east", office
		office.add_room "west", lab
		
		place_item_in_room coke, outside, "on the shelf"
		place_item_in_room chair, theatre, "by the wall"
		place_item_in_room notice_board, theatre, "on the wall"
		place_item_in_room vending_machine, theatre, "next to the wall"
		
		start = ZlQuest.new "start", @player
		start.add_condition 1, "goto", nil, office
		start.add_aftermath 1, "print", nil, nil, 
			["As you enter the Course Admin Office, you suddenly see a flash of bright light."]
		start.add_aftermath 2, "teleport", nil, a1, nil
		start.add_aftermath 3, "print", nil, nil,
			[
				"You look around to find yourself in a small dull room.",
				"You realize that you've entered a realm outside the School of Computing.",
				"You hear a thunderous voice.",
				"Voice of Zuul: I am Zuul the Mighty.",
				"To return to your world, you must listen to what I say and use your head..."
			]
		
		#Level 1
		fireplace = ZlItem.new "fireplace", "a large, unlit FIREPLACE",
			"a large, burning FIREPLACE", "fire", false, 0, -1, nil
		torch = ZlItem.new "torch", "a burning TORCH", nil, "fire", true, 2, -1,
			"The fire is lit."
		rat = ZlItem.new "rat", "a fresh RAT corpse", nil, "gnome", true, 1, 1, nil
		wine = ZlItem.new "wine", "a bottle of fine WINE", nil, "self", true, 2, 1, 
			"It had already oxidized to vinegar..."
		flame_thrower = ZlItem.new "flamethrower", "a hefty FLAMETHROWER", nil, "fire", 
			true, 10, 3, "Target is incinerated."			
		
		a2 = ZlRoom.new 7, "Dining hall", "a large dining hall"
		a3 = ZlRoom.new 8, "Store room", "a musty store room"
		a4 = ZlRoom.new 9, "Workshop", "a messy workshop"
		b1 = ZlRoom.new 10, "Small room", "a small dull room"
		
		a1.add_room "north", a2
		a2.add_room "south", a1
		a2.add_room "east", a3
		a2.add_room "west", a4
		a3.add_room "west", a2
		a4.add_room "east", a2
		
		place_item_in_room fireplace, a2, "against the wall"
		place_item_in_room torch, a3, "on the wall"
		place_item_in_room rat, a3, "on the floor"
		place_item_in_room wine, a3, "on a shelf"
		place_item_in_room flame_thrower, a4, "on the table"
		
		a2.gnomify true
		
		hint_a = ZlQuest.new "hintA", @player
		hint_a.add_condition 1, "goto", nil, a2
		hint_a.add_aftermath 1, "hint", nil, nil, 
			["Don't you think it's a bit chilly on this floor?"]
		start.set_next hint_a
		
		unlock_a = ZlQuest.new "unlockA", @player
		unlock_a.add_condition 1, "configure", (a2.fetch_item "fireplace"), a2
		unlock_a.add_aftermath 1, "print", nil,  nil,
			["You hear some mechanical thudding."]
		unlock_a.add_aftermath 2, "stairway", nil, b1, nil
		hint_a.set_next unlock_a
		
		ending = ZlQuest.new "ending", @player
		ending.add_condition 1, "goto", nil, b1
		ending.add_aftermath 1, "print", nil, nil,
			[
				"Voice of Zuul: This is the end of your journey in the demo version of The Maze of Zuul",
				"*** *** *** *** *** ***",
				"*** *** The END *** ***",
				"*** *** *** *** *** ***"
			]
		unlock_a.set_next ending
		
		@item_catalog = [
			coke, chair, notice_board, vending_machine,
			fireplace, torch, rat, flame_thrower
		]
		
		@room_catalog = [
			outside, theatre, pub, lab, office, a1,
			a2, a3, a4, b1
		]
		
		@quest_catalog = [
			start, hint_a, unlock_a, ending
		]
		
	end
	
	def place_item_in_room item, room, location
		replica = item.replicate
		replica.place_in_location location
		room.add_item replica
	end

end