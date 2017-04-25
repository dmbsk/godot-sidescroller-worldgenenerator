tool
extends EditorPlugin
var map_sizeX = 260 #260
var map_sizeY = 120 
var tile_size = 1
var max_platform_size = 25
var min_platform_size = 2
var platform_height = 4
var min_y_gap = 2
var deltaY = 110
var density = 20
var map = []
var dock; var tile = []
var _tilemap
var _root
var width_label; var height_label;var tilesize_label;var deltaY_label;var density_label;var gap_label
var platformMaxWidth_label; var platformMinWidth_label
func _enter_tree():
	dock = preload("res://addons/mapgenerator/generator_dock.tscn").instance()
	add_control_to_dock( DOCK_SLOT_RIGHT_BL, dock)
	dock.get_node("gen").connect("pressed",self,"map_drawer")
	dock.get_node("clear").connect("pressed",self,"clear_map")
	dock.get_node("width/TextEdit").set_text(str(map_sizeX))
	dock.get_node("height/TextEdit1").set_text(str(map_sizeY))
	dock.get_node("deltaY/TextEdit1").set_text(str(deltaY))
	dock.get_node("density/TextEdit1").set_text(str(density))
	dock.get_node("platform/min/platform_width/TextEdit1").set_text(str(min_platform_size))
	dock.get_node("platform/max/platform_width/TextEdit1").set_text(str(max_platform_size))
	dock.get_node("platform/min/platform_height/TextEdit1").set_text(str(platform_height))
	dock.get_node("platform/min/min_y_gap/TextEdit1").set_text(str(min_y_gap))
	for i in range(0, 10):
		tile.append([])
	for i in range(1, 10):
		var path = "tilepicker/" + str(i)
		tile[i] = dock.get_node(path)
		tile[i].set_text( str(i) )
		print(tile[i])
		

func _exit_tree():
	dock.get_node("gen").disconnect("pressed",self,"map_drawer")
	dock.get_node("clear").disconnect("pressed",self,"clear_map")
	remove_control_from_docks( dock ) # Remove the dock
	dock.free() # Erase the control from the memory
	
func getData():
	_root = get_tree().get_edited_scene_root()
	_tilemap = _root.get_node("World")
	map_sizeX = int(dock.get_node("width/TextEdit").get_text())
	map_sizeY = int(dock.get_node("height/TextEdit1").get_text())
	deltaY = int(dock.get_node("deltaY/TextEdit1").get_text())
	density = int(dock.get_node("density/TextEdit1").get_text())
	max_platform_size = int(dock.get_node("platform/max/platform_width/TextEdit1").get_text())
	min_platform_size = int(dock.get_node("platform/min/platform_width/TextEdit1").get_text())
	platform_height = int(dock.get_node("platform/min/platform_height/TextEdit1").get_text())
	min_y_gap = int(dock.get_node("platform/min/min_y_gap/TextEdit1").get_text())
	
func generateMap():
	map = []
	for i in range(0, map_sizeX + 1):
		map.append([])
		for j in range (0, map_sizeY + 1):
			map[i].append(0)
			map[i][j] = 0
	pass

func generate_floor():
	for i in range(0, density):
		var cell_sum = 0
		var x = 1
		randomize()
		var platform_size = randi()%max_platform_size+min_platform_size
		var rangeY = randi()%(deltaY + 1)
		var y = map_sizeY - rangeY - 2
		while x < map_sizeX - 1:
			randomize()
			if cell_sum < platform_size:
				for j in range(0, platform_height):
					map[x][y-j] = 8
				cell_sum += 1
			else:
				platform_size = randi()%max_platform_size + min_platform_size
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				rangeY = randi()%(deltaY + 1)
				y = map_sizeY - rangeY - 2
				
			x += 1
	pass
func fixGaps():
	for x in range(0, map_sizeX):
		for y in range(0, map_sizeY):
			if y + min_y_gap <= map_sizeY && (map[x][y] == 8 && map[x][y + min_y_gap] == 8):
				var end = (y + min_y_gap) - y + 1
				for j in range( 0, end):
					map[x][y+j] = 8
func mapFixer():
	for x in range(0, map_sizeX):
		for y in range(0, map_sizeY):
			if map[x][y] == 8:
				#center

						#prvar(x, " x " , y+j , "    and start = ", j)
				if map[x-1][y] != 0 && map[x+1][y] == 8 && map[x][y+1] != 0 && map[x][y-1] != 0:
					map[x][y] = 5
						
				#middle no top and bottom block
				elif map[x-1][y] != 0 && map[x+1][y] != 0 && map[x][y+1] == 0 && map[x][y-1] == 0:
					map[x][y] = 85
					
					#bottom	
				elif map[x-1][y] != 0 && map[x+1][y] != 0 && map[x][y+1] == 0 && map[x][y-1] != 0:
					map[x][y] = 2
						
				#left
				if map[x-1][y] == 0:
					if (map[x+1][y] == 8 || map[x+1][y] == 85) && map[x-1][y] == 0:
						map[x][y] = 7
					if map[x][y-1] != 0 && map[x-1][y] == 0:
						map[x][y] = 4
						if map[x+1][y] == 0 && map[x][y+1] != 0:
							map[x][y] = 46
					if map[x][y-1] != 0 && map[x][y+1] == 0 && map[x+1][y] != 0:
						map[x][y] = 1

				#right
				elif map[x-1][y] != 0:
					if map[x+1][y] == 0:
						map[x][y] = 9
					if map[x][y-1] != 0 && map[x+1][y] == 0:
						map[x][y] = 6
					if map[x][y-1] != 0 && map[x][y+1] == 0 && map[x+1][y] == 0:
						map[x][y] = 3
						
				if map[x][y] == 9:
					var friends = 0
					for i in range(x, x+2):
						for j in range (y-1, y+2):
							if map[i][j] != 0 && i*j != x*y:
								friends += 1
					if friends == 0:
						map[x][y] == 66
							 
				elif map[x][y] == 7:
					var friends = 0
					for i in range(x-1, x+1):
						for j in range (y-1, y+2):
							if map[i][j] != 0 && i*j != x*y:
								friends += 1
					if friends == 0:
						map[x][y] == 44
				

	
func map_drawer():
	getData()
	generateMap()
	generate_floor()
	fixGaps()
	mapFixer()
	if map.size() > 0:
		var pos_y = 0
		var pos_x = 0
		#7 8 9			YE GN GN BL
		#4 5 6			OR GR GR CY
		#1 2 3			PG DG DG 
		#void set_cell( int x, int y, int tile, bool flip_x=false, bool flip_y=false, bool transpose=false )
		for x in range(0, map_sizeX):
			for y in range(0, map_sizeY):
				pos_x = ( x * tile_size )
				pos_y = ( y * tile_size )
				if map[x][y] != 0 && map[x][y] != 46:
					var tile_id = int(tile[map[x][y]].get_text())
					_tilemap.set_cell( pos_x, pos_y, tile_id)


func clear_map():
	_tilemap.clear()
