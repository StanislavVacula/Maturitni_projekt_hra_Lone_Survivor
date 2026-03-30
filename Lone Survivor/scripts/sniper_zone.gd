extends Area2D

@onready var shot_sound = $ShootSound
@onready var anim_player = $CanvasLayer/AnimationPlayer

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_physics_process(false)
		
		if body.has_method("hide_hud"):
			body.hide_hud()
		
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").stop()
		
		if shot_sound:
			shot_sound.play()
			
		if body.has_node("AnimationPlayer"):
			body.get_node("AnimationPlayer").play("die")
		
		show_ending_sequence()

func show_ending_sequence():
	if anim_player:
		anim_player.play("final_death_sequence") 
		await anim_player.animation_finished
		_change_to_credits()

func _change_to_credits():
	var tree = Engine.get_main_loop() as SceneTree
	if tree:
		tree.change_scene_to_file("res://scenes/credits.tscn")
