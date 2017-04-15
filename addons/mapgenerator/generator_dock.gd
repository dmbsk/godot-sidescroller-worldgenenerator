tool
extends EditorPlugin
var map_sizeX = 50
var map_sizeY = 30
var tile_size = 16
var max_platform_size = 4
var min_platform_size = 2
var deltaY = 3
var density = 2
var floor_tile_id = 28
var map = []
var sum_cell = 0
var dock
var _tilemap
var _root
var width_label; var height_label;var tilesize_label;var deltaY_label;var density_label;var gap_label
var platformMaxWidth_label; var platformMinWidth_label
func _enter_tree():
	dock = preload("res://addons/mapgenerator/generator_dock.tscn").instance()
	add_control_to_dock( DOCK_SLOT_RIGHT_BL, dock)
	dock.get_node("gen").connect("pressed",self,"generate_map")
	dock.get_node("clear").connect("pressed",self,"clear_map")
	dock.get_node("width/TextEdit").set_text(str(map_sizeX))
	dock.get_node("height/TextEdit1").set_text(str(map_sizeY))
	dock.get_node("tilesize/TextEdit1").set_text(str(tile_size))
	dock.get_node("deltaY/TextEdit1").set_text(str(deltaY))
	dock.get_node("density/TextEdit1").set_text(str(density))
	dock.get_node("platformmaxwidth/TextEdit1").set_text(str(max_platform_size))
	dock.get_node("platformminwidth/TextEdit1").set_text(str(min_platform_size))
	
func _exit_tree():
	remove_control_from_docks( dock ) # Remove the dock
	dock.get_node("gen").disconnect("pressed",self,"generate_map")
	dock.get_node("clear").disconnect("pressed",self,"clear_map")
	dock.free() # Erase the control from the memory
	
func generate_fullmap():
	for i in range(0, map_sizeX):
		map.append([])
		for j in range (0, map_sizeY):
			map[i].append(0)
			sum_cell += 1
	pass
	
func generate_map():
	#get root
	_root = get_tree().get_edited_scene_root()
	
	#create tilemap 28
	_tilemap = _root.get_node("World")
	# set_cell( int x, int y, int tile, bool flip_x=false, bool flip_y=false, bool transpose=false )
	generate_fullmap()
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
				_tilemap.set_cell( x, y, floor_tile_id)
			else:
				#print(str(x+1) + " x " + str(y) + "  ==>   " + str(platform_size))
				platform_size = randi()%max_platform_size + min_platform_size
				var gap_size = randi()%int((max_platform_size*0.5))+1
				x += gap_size
				cell_sum = 0
				rangeY = randi()%(deltaY + 1)
				y = map_sizeY - rangeY - 1
				
			x += 1
	#draw_map()
	
func draw_map():
	if map.size() > 0:
		var color
		var gap = 0
		var pos_y = 0
		var pos_x = 0
		for x in range(0, map_sizeX):
			for y in range(0, map_sizeY):
				if map[x][y] == 1: 
					color = Color(0, 1, 0)
					pos_x = ( x * tile_size ) + x*gap
					pos_y = ( y * tile_size ) + y*gap
					_tilemap.set_cell( x, y, floor_tile_id)

func clear_map():
	_tilemap.clear()
