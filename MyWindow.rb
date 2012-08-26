class MyWindow < Gosu::Window
	def initialize
		super 800, 800, false
		self.caption = 'Ludumia'
		@background_image = Gosu::Image.new(self, "gfx/background.jpg", true)
		
		@menu = Array.new
		@menu_count = 0
		@menu_timer = 0
		@menu.push(Gosu::Image.new(self, "gfx/title.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/title2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/start.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/start2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/instructions.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/instructions2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story3.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/story3.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command2.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command3.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command3.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command4.jpg", true))
		@menu.push(Gosu::Image.new(self, "gfx/command4.jpg", true))
		
		@ludumis = Array.new
		@skulls  = Array.new
		@hearts  = Array.new
		@chosen_ludumi
		
		@game_over = false
		@lose = false
		
		for i in 0..15 do
			@ludumis[i] = Ludumi.new(self)
		end
		
		too_easy = true 
		while too_easy
			@princess = Princess.new(self)
			too_easy = false
			@ludumis.each {|lud| too_easy = true if @princess.img == lud.img}
		end
		
		@font = Gosu::Font.new(self, Gosu::default_font_name, 20)
		
		@song = Gosu::Song.new(self, "sfx/song.ogg")
		@song_title = Gosu::Song.new(self, "sfx/title.ogg")
		@song_title.play(true)
	end

	def update
		
		#menu
		if @menu[@menu_count]
			@menu_timer += 1
			@menu_timer %= 100
			return true 
		end
	
		#game over
		@hearts.each  do |heart|
			heart.timestamp -= 1
			@hearts.delete(heart) if heart.timestamp <= 0
		end
		
		if @game_over
			@hearts.push(Heart.new(rand(800), rand(800), self))
			@ludumis = [@chosen_ludumi]
			return true
		end
	
		@skulls.each  do |skull|
			skull.timestamp -= 1
			@skulls.delete(skull) if skull.timestamp <= 0
		end
		
		if @ludumis == []
			@lose = true
		end
		
		if @lose
			@skulls.push(Skull.new(rand(800), rand(800), self))
			return true
		end
		
		#controls in game
		if button_down? Gosu::KbLeft then
			@princess.left
		end
		if button_down? Gosu::KbRight then
			@princess.right
		end
		if button_down? Gosu::KbUp then
			@princess.up
		end
		if button_down? Gosu::KbDown then
			@princess.down
		end
		
		@princess.kill(@ludumis, @skulls, self)
		
		@ludumis.each_with_index do |lud_top, i| 	
			lud_top.move
			lud_top.libido += 1 unless lud_top.libido == 150
			
			lun_nb = @ludumis.size
			if lun_nb <= 40
				@ludumis.each_with_index do |lud_bot, j|
					if i!= j
						if Gosu::distance(lud_top.x, lud_top.y, lud_bot.x, lud_bot.y) < 20 && lud_top.libido == 150 then
							lud_top.libido = 0
							lud_bot.libido = 0
							lud_top.sex(lud_bot, @ludumis, @hearts, self)
						end
					end
				end
			end
			
			if lud_top.lifespan <= 0
				@skulls.push(Skull.new(lud_top.x, lud_top.y, self))
				@ludumis.delete(lud_top)
			end
		end
		
	end

	def draw
	    @background_image.draw(0, 0, 0);
		@skulls.each	{|skull| skull.draw}
		@hearts.each	{|heart| heart.draw}
	    @princess.draw
		@ludumis.each	{|lud| 	 lud.draw}
		
		@menu[@menu_count+@menu_timer/50].draw(0, 0, 10) if @menu[@menu_count+@menu_timer/50]
	end
	
	def win lud
		@game_over = true
		@chosen_ludumi = lud
	end
	
	def lose
		@lose = true
	end
	
	def button_down(id)
		if id == Gosu::KbEscape
			close
		end
		
		if id == Gosu::KbReturn && @menu_count == 0
			@menu_count = 2
			@menu_timer = 0
			return true
		end		
		
		if id == Gosu::KbDown && @menu_count == 2
			@menu_count = 4
			@menu_timer = 0
			return true
		end
		
		if id == Gosu::KbUp && @menu_count == 4
			@menu_count = 2
			@menu_timer = 0
			return true
		end
		
		if id == Gosu::KbReturn && @menu_count == 2
			@menu_count = 100
			@song_title.stop
			@song.play(true)
			return true
		end
		
		if id == Gosu::KbReturn && @menu_count == 4
			@menu_count = 6 #story
			@menu_timer = 0
			return true
		end
		
		if id == Gosu::KbReturn && @menu_count >= 4
			@menu_count += 2
			
			unless @menu[@menu_count+@menu_timer/50]
				@song_title.stop
				@song.play(true)
			end
			
			return true
		end
		
	end
end
