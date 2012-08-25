class Skull
	attr_reader :img, :x, :y
	
	attr_accessor :timestamp
	
	def initialize(x, y, window)
		@x = x
		@y = y
		@image = Gosu::Image.new(window, "gfx/skull.bmp", false)
		
		@timestamp = 50
	end

	def draw
		@y -= 2 
		@x += rand(5) - 2

		@image.draw(@x, @y, 1)
	end
end