extends CharacterBody2D

const SPEED = 80
const JUMP_VELOCITY = -150

@onready var anim = $AnimatedSprite2D
@onready var jumpSound = $JumpSound

func _physics_process(delta: float) -> void:
	# Gravitace
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Skok
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		jumpSound.play()

	# Pohyb
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	# Otočení podle směru
	if direction != 0:
		anim.flip_h = direction < 0

	move_and_slide()

	# Animace
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")
