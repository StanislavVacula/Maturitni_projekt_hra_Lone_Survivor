extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var controls_button = $VBoxContainer/ControlsButton

@export var game_scene_path: String = "res://scenes/diary_screen_1.tscn" 

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	controls_button.pressed.connect(_on_controls_button_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(game_scene_path)

func _on_quit_pressed():
	get_tree().quit()

func _on_controls_button_pressed():
	get_tree().change_scene_to_file("res://scenes/controls.tscn")


func _on_levels_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level_select.tscn")
