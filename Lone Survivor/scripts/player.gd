extends CharacterBody2D

const SPEED = 130
const JUMP_VELOCITY = -300

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")  # 🎬 přehraj animaci skoku

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	# Animace podle stavu
	if not is_on_floor():
		anim.play("jump")
	elif direction:
		anim.play("walk")
	else:
		anim.play("idle")
