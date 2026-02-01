extends Control

func _ready():
	print("DEATH MENU READY")
	hide()

func show_menu():
	show()
	get_tree().paused = true

func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	
func show_menu2():
	print("Viewport:", get_viewport_rect().size)
	print("Canvas transform:", get_canvas_transform())
	show()
	get_tree().paused = true
