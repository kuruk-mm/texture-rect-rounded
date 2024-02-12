@tool
extends EditorPlugin


func _enter_tree():
	add_custom_type(
		"TextureRectRounded",
		"Control",
		load("res://addons/TextureRectRounded/TextureRectRounded.gd"),
		load("res://addons/TextureRectRounded/TextureRectRounded.svg")
	)


func _exit_tree():
	remove_custom_type("TextureRectRounded")
