var map_test_sizeX = 260 #260
var map_test_sizeY = 120 
var tile_size = 5
var max_platform_size = 5
var min_platform_size = 2
var min_platform_height = 3
var max_platform_height = 5
var min_y_gap = 2
var flatter_distance = 2
var deltaY = 110
var density = 30
var map_test = []
var sum_cell = 0
func _ready():
	for i in range(0, map_test_sizeX + 1):
		map_test.append([])
		for j in range (0, map_test_sizeY + 1):
			map_test[i].append(0)
			sum_cell += 1
			map_test[i][j] = 0
	pass

func generate_floor():

	for i in range(0, density):
		var cell_sum = 0
		var x = 1
		randomize()
		var platform_size = randi()%max_platform_size+min_platform_size
		randomize()
		var rangeY = randi()%(deltaY + 1)
		var y = map_test_sizeY - rangeY - 2
		while x < map_test_sizeX - 1:
			if cell_sum < platform_size:
				randomize()
				var platform_height =  int(rand_range(min_platform_height, max_platform_height + 1))
				print(platform_height)
				for j in range(0, platform_height):
					map_test[x][y-j] = 8
				cell_sum += 1
			else:
				randomize()
				platform_size = randi()%max_platform_size + min_platform_size
				randomize()
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				randomize()
				rangeY = randi()%(deltaY + 1)
				y = map_test_sizeY - rangeY - 2
				
			x += 1
	pass
	
func fixGaps():
	for x in range(0, map_test_sizeX):
		for y in range(0, map_test_sizeY):
			if y + min_y_gap <= map_test_sizeY && (map_test[x][y] == 8 && map_test[x][y + min_y_gap] == 8):
				var end = (y + min_y_gap) - y + 1
				for j in range( 0, end):
					map_test[x][y+j] = 8
					
func map_flatter(flatness_strenght):
	for j in range(0, flatness_strenght):
		for x in range(0, map_test_sizeX):
			for y in range(0, map_test_sizeY):
				if map_test[x][y] == 0 && map_test[x][y+1] == 8 && map_test[x-1][y] == 8:
					map_test[x][y] = 8;
					
func map_flipper(var axis):
	if axis.length() > 0:
		var map_copy = []
		for i in range(0, map_test_sizeX + 1):
			map_copy.append([])
			for j in range (0, map_test_sizeY + 1):
				map_copy[i].append(0)
				map_copy[i][j] = map_test[i][j]
		if axis == "x":
			for x in range (map_test_sizeX, 0, -1):
				for y in range (0, map_test_sizeY):
					var reverse = map_test[x].size()
					map_test[x][y] == map_copy[reverse - x][y]
		elif axis == "y":
			for x in range (0, map_test_sizeX + 1):
				for y in range (map_test_sizeY, 0, -1):
					var reverse = map_test[y].size()
					map_test[x][y] == map_copy[x][reverse - y]
		elif axis == "xy" || axis == "yx":
			for x in range (map_test_sizeY, 0, -1):
				for y in range (map_test_sizeY, 0, -1):
					var reverse_x = map_test[x].size()
					var reverse_y = map_test[y].size()
					map_test[x][y] == map_copy[reverse_x - x][reverse_y - y]
func platform_flipper(var axis):
	if axis.length() > 0:
		var map_copy = []
		for i in range(0, map_test_sizeX + 1):
			map_copy.append([])
			for j in range (0, map_test_sizeY + 1):
				map_copy[i].append(0)
				map_copy[i][j] = map_test[i][j]
		if axis == "x":
			for x in range (map_test_sizeX, 0, -1):
				for y in range (0, map_test_sizeY):
					var reverse = map_test[x].size()
					map_test[x][y] == map_copy[reverse - x][y]
		elif axis == "y":
			for x in range (0, map_test_sizeX + 1):
				for y in range (0, map_test_sizeY + 1):
					var center = 60#int(map_test[y].size() / 2)
					if y < center && map_test[x][y] == 8:
						map_test[x][y] == map_copy[x][center - abs(center - y)]
						print( center - abs(center - y), " to ", y)
					else:
						map_test[x][y] == map_copy[x][center + abs(center - y)]
		elif axis == "xy" || axis == "yx":
			for x in range (map_test_sizeY, 0, -1):
				for y in range (map_test_sizeY, 0, -1):
					var reverse_x = map_test[x].size()
					var reverse_y = map_test[y].size()
					map_test[x][y] == map_copy[reverse_x - x][reverse_y - y]
func mapFixer():
	for x in range(0, map_test_sizeX):
		for y in range(0, map_test_sizeY):
			if map_test[x][y] == 8:
				#center

						#prvar(x, " x " , y+j , "    and start = ", j)
				if map_test[x-1][y] != 0 && map_test[x+1][y] == 8 && map_test[x][y+1] != 0 && map_test[x][y-1] != 0:
					map_test[x][y] = 5
						
				#middle no top and bottom block
				elif map_test[x-1][y] != 0 && map_test[x+1][y] != 0 && map_test[x][y+1] == 0 && map_test[x][y-1] == 0:
					map_test[x][y] = 85
					
					#bottom	
				elif map_test[x-1][y] != 0 && map_test[x+1][y] != 0 && map_test[x][y+1] == 0 && map_test[x][y-1] != 0:
					map_test[x][y] = 2
						
				#left
				if map_test[x-1][y] == 0:
					if (map_test[x+1][y] == 8 || map_test[x+1][y] == 85) && map_test[x-1][y] == 0:
						map_test[x][y] = 7
					if map_test[x][y-1] != 0 && map_test[x-1][y] == 0:
						map_test[x][y] = 4
						if map_test[x+1][y] == 0 && map_test[x][y+1] != 0:
							map_test[x][y] = 46
					if map_test[x][y-1] != 0 && map_test[x][y+1] == 0 && map_test[x+1][y] != 0:
						map_test[x][y] = 1

				#right
				elif map_test[x-1][y] != 0:
					if map_test[x+1][y] == 0:
						map_test[x][y] = 9
					if map_test[x][y-1] != 0 && map_test[x+1][y] == 0:
						map_test[x][y] = 6
					if map_test[x][y-1] != 0 && map_test[x][y+1] == 0 && map_test[x+1][y] == 0:
						map_test[x][y] = 3
						
				if map_test[x][y] == 9:
					var friends = 0
					for i in range(x, x+2):
						for j in range (y-1, y+2):
							if map_test[i][j] != 0 && i*j != x*y:
								friends += 1
					if friends == 0:
						map_test[x][y] == 66
							 
				elif map_test[x][y] == 7:
					var friends = 0
					for i in range(x-1, x+1):
						for j in range (y-1, y+2):
							if map_test[i][j] != 0 && i*j != x*y:
								friends += 1
					if friends == 0:
						map_test[x][y] == 44
				

	
func _draw():
	generate_floor()
	#platform_flipper("y")
	map_flipper("y")
	map_flatter(1)
	map_flipper("y")
	map_flatter(1)
	map_flipper("y")
	map_flatter(1)
	map_flipper("y")
	map_flatter(1)
	fixGaps()
	mapFixer()
	if map_test.size() > 0:
		var color
		var gap = 1
		var pos_y = 0
		var pos_x = 0
		#7 8 9			YE GN GN BL
		#4 5 6			OR GR GR CY
		#1 2 3			PG DG DG 
		for x in range(0, map_test_sizeX):
			for y in range(0, map_test_sizeY):
				pos_x = ( x * tile_size ) + x*gap
				pos_y = ( y * tile_size ) + y*gap
				var rect2 = Rect2( pos_x, pos_y, tile_size, tile_size)
				color = colorReturner(map_test[x][y])
				draw_rect( rect2, color)
func colorReturner(c):
	return{
		7: Color(1, 0.4, 0), ## orange / left corner
		8: Color(0, 1, 0), ## green / grass / top
		9: Color(0, 0.3, 1), ## Blue / right corner
		4: Color(1, 1, 0), ## Yellow / left wall
		5: Color(0, 0, 0), ## black / center
		6: Color(0, 0.9, 1), ## lt blue / right wall
		1: Color(1, 0.3, 0.6), ## pink / bottom left
		2: Color(0.5, 0.5, 0.5), ## gray / bottom
		3: Color(0.33, 0, 0.8), ## violet / bottom right
		
		##special 
		#platform height == 1
		85: Color(0.3, 1, 0.3), ## center
		44: Color(1, 0.05, 0), ## left 
		66: Color(1, 1, 1), ## right
		
		#platform width = 1
		46: Color(0.35, 0.35, 0.35), # gray left and right
		426: Color(0.2, 0.2, 0.2), # gray left bottom right
		486: Color(0.2, 0.8, 0.1), # green left top rightt
		#air?
		0: Color(0, 0, 0, 0),
		
		#wip
		55: Color(0, 0, 0, 0.5), ## black fixed gap y
	}[c]

func blockType(t):
	return{
		#center
	}[t]