class Ludumi
	attr_accessor 	:img, :libido, :image, :lifespan, :panic, :distorted_coef, :timer, :panic_text
	attr_reader 	:x, :y, :l, :t, :r
	
	def initialize(window)
		@l = (rand 3).to_s
		@t = (rand 4).to_s
		@r = (rand 3).to_s
		
		@img = "gfx/" + @l + "_" + @t + "_" + @r + ".bmp"
		
		@image = Gosu::Image.new(window, @img, false)
		
		@libido = 150 #timer: want sex when libido >= 150
		
		@x = rand 768
		@y = rand 776
		
		@distorted_coef = rand 4
		@timer = 0
		
		@lifespan = 1000 + rand(2000)
		
		@panic_text = ['hii!!', 'aah!!', 'save me!', 'oh GOD', 'dont wanz die', 'bitch!', 'stop her!', 'holy shit'][rand(8)]
		@panic = 0
	end

	def put(x, y)
		@x, @y = x, y
	end
	
	def genetic(l, t, r)
		@l, @t, @r = l, t, r
	end

	def move
		@timer += 1
		@lifespan -= 1
		
		if @timer >= 50 
			@distorted_coef = rand 4
			@panic = 0
			@timer = 0
		end
	
		if @x <= 768  
			@x += rand(4)+panic unless @distorted_coef == 0
		else
			@distorted_coef = 0 # bounce on walls
		end
		
		if @x >= 0
			@x -= rand(4)+panic unless @distorted_coef == 1
		else
			@distorted_coef = 1
		end
		
		if @y <= 776
			@y += rand(4)+panic if @y <= 776 unless @distorted_coef == 2
		else
			@distorted_coef = 2
		end
		
		if @y >= 0
			@y -= rand(4)+panic unless @distorted_coef == 3
		else
			@distorted_coef = 3
		end
	end
	
	def sex(lud, ludumis, hearts, window)
		princess = window.princess
		
		# trigger mutations to make the game easier
		needl = true
		needt = true
		needr = true
		
		ludumis.each do |lud|
			needl = false if lud.l == princess.l
			needt = false if lud.t == princess.t
			needr = false if lud.r == princess.r
		end
	
		if rand(2) == 1
			l = @l
			l = princess.l if needl
		else
			l = lud.l
		end
		
		if rand(2) == 1
			t = @t
			t = princess.t if needt
		else
			t = lud.t
		end
		
		if rand(2) == 1
			r = @r
			r = princess.r if needr
		else 
			r = lud.r
		end
		
		baby_lud = Ludumi.new(window)
		
		# mutations
		if rand(80) != 0
			img = "gfx/" + l + "_" + t + "_" + r + ".bmp"
			baby_lud.img 	= img
			baby_lud.image 	= Gosu::Image.new(window, img, false)
			baby_lud.genetic(l, t, r)
		end
		
		baby_lud.libido = 0
		baby_lud.put(lud.x, lud.y)
		hearts.push(Heart.new(lud.x, lud.y, window))
		ludumis.push baby_lud
	end

	def draw
		@image.draw(@x, @y, 1)
	end
end