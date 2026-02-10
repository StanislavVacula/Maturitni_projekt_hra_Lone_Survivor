extends CharacterBody2D

const SPEED = 80
const JUMP_VELOCITY = -300

var input_enabled := true
var bullet_scene: PackedScene
@onready var muzzle: Node2D = $Muzzle

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jumpSound = $JumpSound

func _physics_process(delta: float) -> void:
	if not input_enabled:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("jump")
		jumpSound.play()

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0

	move_and_slide()

	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")

	if Input.is_action_just_pressed("shoot"):
		fire()

func fire():
	if bullet_scene == null:
		print("❌ bullet_scene není nastavená!")
		return

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)

	bullet.global_position = muzzle.global_position
