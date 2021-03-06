class ZlItem
	attr_reader :name, :description, :description2, 
				:location, :type, :portable, :evolved,
				:charge, :weight, :effect_message
				
	def initialize name, description, effect_message, options={}
		@name = name
		@description = description
		@description2 = options[:description2]
		@type = options[:type] || "self"
		@portable = options[:portable] || false
		@weight = options[:weight] || 0
		@charge = options[:charge] || -1
		@effect_message = effect_message
	end
	
	def replicate
		replica = ZlItem.new @name, @description, @effect_message, 
			description2: @description2, 
			type: @type, 
			portable: @portable, 
			weight: @weight, 
			charge: @charge, 
			effect_message: @effect_message
	end
	
	def is_compatible_with?(another_item)
		@type == another_item.type
	end
	
	def expend
		@charge -= 1
	end
	
	def take_effect
		expend if charge > 0
		puts @effect_message
	end
	
	def has_evolved?
		@evolved
	end
	
	def is_portable?
		@portable
	end
	
	def evolve
		@evolved = true
	end
	
	def short_description
		"#{@name}"
	end
	
	def long_description
		"#{has_evolved? ? @description2 : @description} #{@location}"
	end
	
	def place_in_location location
		@location = location
	end
	
end