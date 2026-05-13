extends Control

@onready var tutorial_button = $VBoxContainer/TutorialButton 

func _ready():
	tutorial_button.grab_focus()

func _on_tutorial_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/diary_screen_1.tscn")

func _on_mission_2_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/diary_screen_2.tscn")

func _on_mission_3_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/diary_screen_3.tscn")

func _on_mission_4_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/diary_screen_4.tscn")

func _on_back_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
