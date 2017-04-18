var map_test_sizeX = 260
var map_test_sizeY = 120
var tile_size = 5
var max_platform_size = 4
var min_platform_size = 2
var platform_height = 5
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
func mapFixer():
	print("mapfixer")
	
func _draw():
	generate_floor()
	if map_test.size() > 0:
		var color
		var gap = 0
		var pos_y = 0
		var pos_x = 0
		#7 8 9			YE GN GN BL
		#4 5 6			OR GR GR CY
		#1 2 3			PG DG DG 
		for x in range(0, map_test_sizeX):
			for y in range(0, map_test_sizeY):
				if map_test[x][y] == 8: 
					color = Color(0, 1, 0) ## green
					#center
					if map_test[x-1][y] != 0 && map_test[x+1][y] == 8 && map_test[x][y+1] != 0 && map_test[x][y-1] != 0:
						color = Color(0, 0, 0) ## Black
						map_test[x][y] = 5
						
					#middle no top and bottom block
					elif map_test[x-1][y] != 0 && map_test[x+1][y] != 0 && map_test[x][y+1] == 0 && map_test[x][y-1] == 0:
						color = Color(0.3, 1, 0.3) ## lt green
						map_test[x][y] = 85
					
					#bottom	
					elif map_test[x-1][y] != 0 && map_test[x+1][y] != 0 && map_test[x][y+1] == 0 && map_test[x][y-1] != 0:
						color = Color(0.5, 0.5, 0.5) ## gray
						map_test[x][y] = 2
						
					#left
					if map_test[x-1][y] == 0:
						if (map_test[x+1][y] == 8 || map_test[x+1][y] == 85) && map_test[x-1][y] == 0:
							color = Color(1, 0.4, 0) ## Orange
							map_test[x][y] = 7
						if map_test[x][y-1] != 0 && map_test[x-1][y] == 0:
							color = Color(1, 1, 0) ## Yellow
							map_test[x][y] = 4
						if map_test[x][y-1] != 0 && map_test[x][y+1] == 0 && map_test[x+1][y] != 0:
							color = Color(1, 0.3, 0.6) ## Pink
							map_test[x][y] = 1

					#right
					elif map_test[x-1][y] != 0:
						if map_test[x+1][y] == 0:
							color = Color(0, 0.3, 1) ## Blue
							map_test[x][y] = 9
						if map_test[x][y-1] != 0 && map_test[x+1][y] == 0:
							color = Color(0, 0.9, 1) ## lt blue
							map_test[x][y] = 6
						if map_test[x][y-1] != 0 && map_test[x][y+1] == 0 && map_test[x+1][y] == 0:
							color = Color(0.33, 0, 0.8) ## violet
							map_test[x][y] = 3
							
					if map_test[x][y] == 9:
						var friends = 0
						for i in range(x, x+2):
							for j in range (y-1, y+2):
								if map_test[i][j] != 0 && i*j != x*y:
									friends += 1
						if friends == 0:
							color = Color(1, 1, 1)
							map_test[x][y] == 66
							 
					elif map_test[x][y] == 7:
						var friends = 0
						var done = false
						for i in range(x-1, x+1):
							for j in range (y-1, y+2):
								if map_test[i][j] != 0 && i*j != x*y:
									friends += 1
						if friends == 0:
							color = Color(1, 0.05, 0)
							map_test[x][y] == 44
				#border
				elif x == map_test_sizeX-1 || y == map_test_sizeY-1 || x == 0 || y == 0:
					color = Color(1, 1, 1, 0.05)
				#air
				else:
					color = Color(0, 0, 0, 0)
				pos_x = ( x * tile_size ) + x*gap
				pos_y = ( y * tile_size ) + y*gap
				var rect2 = Rect2( pos_x, pos_y, tile_size, tile_size)
				draw_rect( rect2, color)