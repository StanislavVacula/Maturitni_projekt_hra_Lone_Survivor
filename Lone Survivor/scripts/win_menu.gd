extends Control

@export var next_mission_path: String = "" 

@onready var mission_completed_sound = $MissionCompleted
@onready var anim_player = $AnimationPlayer
@onready var next_mission_button = $VBoxContainer/NextMissionButton 

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	if anim_player:
		anim_player.play("RESET")

func show_win():
	show()
	get_tree().paused = true
	
	if next_mission_button:
		next_mission_button.grab_focus()
	
	if anim_player and anim_player.has_animation("fade_in"):
		anim_player.play("fade_in")
	
	if mission_completed_sound and mission_completed_sound.stream:
		mission_completed_sound.play()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_next_mission_button_pressed() -> void:
	get_tree().paused = false
	
	if next_mission_path != "":
		get_tree().change_scene_to_file(next_mission_path)
	else:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
