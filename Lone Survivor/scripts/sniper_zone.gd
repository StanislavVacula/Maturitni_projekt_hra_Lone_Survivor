extends Area2D
@onready var shot_sound = $ShootSound
@onready var blood_rect = $CanvasLayer/ColorRect 
@onready var quote_label = $CanvasLayer/QuoteText 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_physics_process(false) 
		
		if body.has_node("AnimatedSprite2D"):
			body.get_node("AnimatedSprite2D").stop() 
		
		if shot_sound:
			shot_sound.play()
		
		if body.has_node("AnimationPlayer"):
			body.get_node("AnimationPlayer").play("die")
		
		if blood_rect:
			blood_rect.color = Color(1, 0, 0, 0)
			var t = create_tween()
			t.tween_property(blood_rect, "color:a", 0.8, 0.05) 
			t.tween_property(blood_rect, "color:a", 0.4, 0.5) 

		await get_tree().create_timer(3.0).timeout
		
		if blood_rect and quote_label:
			var final_tween = create_tween()
			
			final_tween.tween_property(blood_rect, "color", Color(0, 0, 0, 1), 3.0)
			
			final_tween.tween_property(quote_label, "modulate:a", 1.0, 2.0).set_delay(0.5) 
			
			await final_tween.finished
		await get_tree().create_timer(4.0).timeout
		get_tree().change_scene_to_file("res://scenes/credits.tscn")
