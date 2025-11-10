extends CharacterBody2D

const SPEED = 50
const JUMP_VELOCITY = -300

@onready var anim = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Gravitace
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Skok
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")

	# Pohyb
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0:
		velocity.x = direction * SPEED
		anim.flip_h = direction < 0
	else:
		velocity.x = 0  # 👈 okamžité zastavení, žádné klouzání

	move_and_slide()

	# Animace
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")
