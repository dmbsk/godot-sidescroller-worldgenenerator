tool
extends EditorPlugin
export var map_sizeX = 50
export var map_sizeY = 30
export var tile_size = 10
export var max_platform_size = 4
export var min_platform_size = 2
export var deltaY = 3
export var density = 2
var map = []
var sum_cell = 0
func _enter_tree():
	for i in range(0, map_sizeX):
		map.append([])
		for j in range (0, map_sizeY):
			map[i].append(0)
			sum_cell += 1
			
	pass
func _exit_tree():
	pass

func path():
	for i in range(0, density):
		var cell_sum = 0
		var x = 0
		randomize()
		var platform_size = randi()%max_platform_size+min_platform_size
		var rangeY = randi()%(deltaY + 1)
		var y = map_sizeY - rangeY -1
		#print(str(x) + "," + str(y) + " = " + str(platform_size))
		while x < map_sizeX:
			randomize()
			if cell_sum < platform_size:
				cell_sum += 1
				map[x][y] = 1
			else:
				#print(str(x+1) + " x " + str(y) + "  ==>   " + str(platform_size))
				platform_size = randi()%max_platform_size + min_platform_size
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				rangeY = randi()%(deltaY + 1)
				y = map_sizeY - rangeY - 1
				
			x += 1
	pass

func _draw():
	path()
	var color
	var gap = 0
	var pos_y = 0
	var pos_x = 0
	for x in range(0, map_sizeX):
		for y in range(0, map_sizeY):
			if map[x][y] == 1: 
				color = Color(0, 1, 0)
				var new_node = Node.new()
				new_node.set("Type", Sprite)
				var tex = load("res://icon.png")
				print(tex)
				
				new_node.set_name("tile" , x , "x" , y)
				get_scene().add_child(new_node)
				new_node.set_owner(get_scene())
			elif x == map_sizeX-1 || y == map_sizeY-1 || x == 0 || y == 0:
				color = Color(1, 0, 0)
			else:
				color = Color(0, 0, 0, 0)
			pos_x = ( x * tile_size ) + x*gap
			pos_y = ( y * tile_size ) + y*gap
			var rect2 = Rect2( pos_x, pos_y, tile_size, tile_size)
			draw_rect( rect2, color)
			
	