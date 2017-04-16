export var map_test_sizeX = 100
export var map_test_sizeY = 30
export var tile_size = 10
export var max_platform_size = 4
export var min_platform_size = 2
export var deltaY = 15
export var density = 2
var map_test = []
var sum_cell = 0
func _ready():
	for i in range(0, map_test_sizeX):
		map_test.append([])
		for j in range (0, map_test_sizeY):
			map_test[i].append(0)
			sum_cell += 1
			
	pass

func generate_floor():
	for i in range(0, density):
		var cell_sum = 0
		var x = 0
		randomize()
		var platform_size = randi()%max_platform_size+min_platform_size
		var rangeY = randi()%(deltaY + 1)
		var y = map_test_sizeY - rangeY -1
		#print(str(x) + "," + str(y) + " = " + str(platform_size))
		while x < map_test_sizeX:
			randomize()
			if cell_sum < platform_size:
				cell_sum += 1
				map_test[x][y] = 1
			else:
				#print(str(x+1) + " x " + str(y) + "  ==>   " + str(platform_size))
				platform_size = randi()%max_platform_size + min_platform_size
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				rangeY = randi()%(deltaY + 1)
				y = map_test_sizeY - rangeY - 1
				
			x += 1
	pass

func _draw():
	generate_floor()
	if map_test.size() > 0:
		var color
		var gap = 1
		var pos_y = 0
		var pos_x = 0
		for x in range(0, map_test_sizeX):
			for y in range(0, map_test_sizeY):
				if map_test[x][y] == 1: 
					color = Color(0, 1, 0)
				elif x == map_test_sizeX-1 || y == map_test_sizeY-1 || x == 0 || y == 0:
					color = Color(1, 0, 0)
				else:
					color = Color(0, 0, 0, 0)
				pos_x = ( x * tile_size ) + x*gap
				pos_y = ( y * tile_size ) + y*gap
				var rect2 = Rect2( pos_x, pos_y, tile_size, tile_size)
				draw_rect( rect2, color)