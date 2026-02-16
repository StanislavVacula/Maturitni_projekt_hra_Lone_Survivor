extends CharacterBody2D

@export var speed := 600.0
@export var lifetime := 3.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	if direction == Vector2.ZERO:
		return

	velocity = direction * speed
	move_and_slide()


func _on_body_entered(body):
	if body.is_in_group("enemy"):
		return

	queue_free()
