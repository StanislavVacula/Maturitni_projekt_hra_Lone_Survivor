extends CharacterBody2D

var dir: float
var speed := 800

func _physics_process(delta):
	velocity = Vector2.RIGHT.rotated(dir) * speed
	move_and_slide()
