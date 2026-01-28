extends Control

func _ready():
	hide()

func show_menu():
	show()
	get_tree().paused = true

func _on_restart_button_pressed() -> void:
	print("restart click")
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_button_pressed() -> void:
	print("back to menu click")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
