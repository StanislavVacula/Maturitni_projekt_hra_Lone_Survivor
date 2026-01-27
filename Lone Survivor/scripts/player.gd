extends CharacterBody2D

const SPEED := 80
const JUMP_VELOCITY := -300

var input_enabled := true

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpSound: AudioStreamPlayer2D = $JumpSound

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Skok
	if input_enabled and Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		jumpSound.play()

	# Pohyb
	var direction := 0.0
	if input_enabled:
		direction = Input.get_axis("ui_left", "ui_right")

	velocity.x = direction * SPEED

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
