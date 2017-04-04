class ZlGnome

	attr_reader :level, :count, :retorts, :screams
	
	def initialize
		@level = 0
		@count = 0
		@retorts = [
			["Whaddya want?", "I am calm, you calm down!", "Go away."],
			["Hiya again.", "Don't like you either.", "You stink.", "Go away."]
		]
		@screams = [
			"Yikes, I hate rats! I'm outta 'ere!"
		]
	end
	
	def level_up
		@level += 1
	end
	
	def retort
		str = "Gnome: " << @retorts[@level][@count]
		if (@count + 1 < @retorts[@level].length) then
			@count += 1
		end
		str
	end
	
	def scream
		"Gnome: " << @screams[@level]  << "\nThe gnome runs away..."
	end
	
end