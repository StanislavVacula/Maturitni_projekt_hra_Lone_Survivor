extends Control

func _ready():
	visible = false

func show_win():
	visible = true
	get_tree().paused = true 

func _on_next_level_pressed():
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/level_2.tscn")
