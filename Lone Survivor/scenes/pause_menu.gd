extends Control

func _ready():
	hide()
	$AnimationPlayer.play("RESET")
	process_mode = Node.PROCESS_MODE_ALWAYS

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	
	await $AnimationPlayer.animation_finished
	if !get_tree().paused:
		hide()

func pause():
	show()
	get_tree().paused = true
	$AnimationPlayer.play("blur")

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
