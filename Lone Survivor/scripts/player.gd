extends CharacterBody2D

const SPEED = 80
const JUMP_VELOCITY = -300

var input_enabled := true

@onready var anim = $AnimatedSprite2D
@onready var jumpSound = $JumpSound

func _physics_process(delta: float) -> void:
	if not input_enabled:
		return

	# gravitace
	if not is_on_floor():
		velocity += get_gravity() * delta

	# skok
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		jumpSound.play()

	# pohyb
	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0

	move_and_slide()

	# animace
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")
