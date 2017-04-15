tool
extends EditorPlugin

var dock # A class member to hold the dock during the plugin lifecycle
var mainGuiPath = "VBoxContainer/PanelContainer/VBoxContainer/"

func _enter_tree():
	
	dock = preload("res://addons/mapgenerator/generator_dock.tscn").instance()
	add_control_to_dock( DOCK_SLOT_RIGHT_BL, dock)
	dock.get_node("Button").connect("pressed",self,"generate_map")
	
func _exit_tree():

	remove_control_from_docks( dock ) # Remove the dock
	dock.get_node("Button").disconnect("pressed",self,"generate_map")
	dock.free() # Erase the control from the memory

func generate_map():
	var _root = get_tree().get_edited_scene_root()
	print(root)
	#if _user_tilemap.
	var _new_sprite = Sprite.new()
	var _new_texture = ImageTexture.new()
	_new_texture.load("floor.png")
	_new_texture.set_flags(0)
	_new_sprite.set_texture(_new_texture)
	_root.add_child(_new_sprite)
	_new_sprite.set_pos(Vector2(0, 0))
	_new_sprite.set_owner(_root)
	_new_sprite.set_name("floor")