tool
extends Control

func _enter_tree():
    get_node("Button").connect("pressed", self, "clicked")

func clicked():
    print("You clicked me!")