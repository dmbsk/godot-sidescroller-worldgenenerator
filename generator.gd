var map_test_sizeX = 210 #260
var map_test_sizeY = 100 
var tile_size = 5
var max_platform_size = 5
var min_platform_size = 3
var platform_height = 5
var min_y_gap = 2
var deltaY = 80
var density = 10
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
		var rangeY = randi()%(deltaY + 1)
		var y = map_test_sizeY - rangeY - 2
		while x < map_test_sizeX - 1:
			randomize()
			if cell_sum < platform_size*platform_height:
				for j in range(0, platform_height):
					map_test[x][y-j] = 8
				cell_sum += 1
			else:
				platform_size = randi()%max_platform_size + min_platform_size
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				rangeY = randi()%(deltaY + 1)
				y = map_test_sizeY - rangeY - 2
				
			x += 1
	pass
func fixGaps():
	for x in range(0, map_test_sizeX):
		for y in range(0, map_test_sizeY):
			if map_test[x][y] == 8 && map_test[x][y + min_y_gap] == 8:
				var end = (y + min_y_gap) - y + 1
				for j in range( 0, end):
					map_test[x][y+j] = 8
func mapFixer():
	for x in range(0, map_test_sizeX):
		for y in range(0, map_test_sizeY):
			if map_test[x][y] == 8:
				#center

						#print(x, " x " , y+j , "    and start = ", j)
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
					var done = false
					for i in range(x-1, x+1):
						for j in range (y-1, y+2):
							if map_test[i][j] != 0 && i*j != x*y:
								friends += 1
					if friends == 0:
						map_test[x][y] == 44
				

	
func _draw():
	generate_floor()
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
		
		#air?
		0: Color(0, 0, 0, 0),
		
		#wip
		55: Color(0, 0, 0, 0.5), ## black fixed gap y
	}[c]

func blockType(t):
	return{
		#center
	}[t]