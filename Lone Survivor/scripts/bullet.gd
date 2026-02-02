extends Area2D

@export var speed: float = 400  
var direction: int = 1          

func _physics_process(delta):
	position.x += speed * direction * delta

	if position.x < 0 or position.x > get_viewport_rect().size.x:
		queue_free()
