extends Control
@onready var back_button = $BackToMenuButton 

func _ready():
	back_button.grab_focus()

func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
