extends Control

@onready var play_button = $VBoxContainer/PlayButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var options_panel = $OptionsPanel

@export var game_scene_path: String = "res://scenes/tutorial.tscn" 

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file(game_scene_path)

func _on_quit_pressed():
	get_tree().quit()
	
func _on_options_button_pressed():
	options_panel.show()

func _on_back_button_pressed():
	options_panel.hide()
