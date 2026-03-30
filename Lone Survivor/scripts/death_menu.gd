extends Control

@onready var death_sound = $DeathSound

func _ready():
	hide()
	$AnimationPlayer.play("RESET") 

func show_death():
	if death_sound:
		death_sound.play()
	
	show()
	$AnimationPlayer.play("death_sequence") 
	
	await get_tree().create_timer(1.2).timeout
	get_tree().paused = true

func _on_restart_button_pressed():
	get_tree().paused = false 
	get_tree().reload_current_scene()

func _on_menu_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
