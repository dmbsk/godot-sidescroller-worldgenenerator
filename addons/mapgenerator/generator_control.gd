tool
extends Control

func _enter_tree():
	get_node("gen").connect("pressed", self, "gen")
	get_node("clear").connect("pressed", self, "clear")

func gen():
	print("You clicked gen!")

func clear():
	print("clear!")