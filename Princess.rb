class Princess
	attr_reader :img
	
	def initialize(window)
		@l = (rand 3).to_s
		@t = (rand 4).to_s
		@r = (rand 3).to_s
		@img = "gfx/" + @l + "_" + @t + "_" + @r + ".bmp"
		
		@image = Gosu::Image.new(window, @img, false)
		@x = @y = 400
		
		@hiii = Gosu::Sample.new(window, "sfx/hiii.wav")
	end

	def right
		@x += 4 if @x <= 768
	end
	
	def left
		@x -= 4 if @x >= 0 
	end

	def down
		@y += 4 if @y <= 776
	end
	
	def up
		@y -= 4 if @y >= 0
	end

	def kill(ludumis, skulls, window)
		ludumis.reject! do |lud|
			if Gosu::distance(@x, @y, lud.x, lud.y) < 20 then
				if  @img != lud.img
					skulls.push(Skull.new(lud.x, lud.y, window))
					@hiii.play
					true
				else
					window.win(lud)
					false
				end
			end
		end
	end
	
	def draw
		@image.draw(@x, @y, 1, 1, 1, Gosu::Color.new(0xffFF0000))
	end
end