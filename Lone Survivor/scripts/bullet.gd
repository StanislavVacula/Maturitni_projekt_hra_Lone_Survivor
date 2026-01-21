extends Area2D

@export var speed := 100
var direction := 1

func _process(delta):
	position.x += speed * direction * delta

func _on_body_entered(body):
	if body.is_in_group("player"):
		print("HIT PLAYER")
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
