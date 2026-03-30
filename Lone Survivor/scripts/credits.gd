extends Control

@onready var anim_player = $AnimationPlayer

func _ready():
	if anim_player:
		anim_player.play("roll_credits")
		anim_player.animation_finished.connect(_on_animation_finished)

func _input(event):
	if event is InputEventKey and event.pressed:
		_back_to_menu()
	elif event is InputEventMouseButton and event.pressed:
		_back_to_menu()

func _on_animation_finished(_anim_name):
	_back_to_menu()

func _back_to_menu():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
