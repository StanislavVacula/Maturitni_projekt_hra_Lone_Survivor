extends CharacterBody2D

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

@export var bullet_scene: PackedScene
@export var max_health := 3

var health: int
var is_dead := false
var input_enabled := true

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var muzzle: Node2D = $Muzzle
@onready var health_label: Label = get_tree().current_scene.find_child("HealthLabel", true, false)

func _ready():
	health = max_health
	add_to_group("player")
	update_ui()

func _physics_process(delta: float) -> void:
	if not input_enabled or is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if jump_sound: jump_sound.play()

	var direction := Input.get_axis("ui_left", "ui_right")
	velocity.x = direction * SPEED

	if direction != 0:
		anim.flip_h = direction < 0
		muzzle.position.x = abs(muzzle.position.x) * sign(direction)

	move_and_slide()
	update_animations(direction)

	if Input.is_action_just_pressed("shoot"):
		fire()

func update_animations(direction):
	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")

func fire():
	if bullet_scene == null: return
	var bullet = bullet_scene.instantiate()
	var shoot_dir = Vector2.LEFT if anim.flip_h else Vector2.RIGHT
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	if "direction" in bullet:
		bullet.direction = shoot_dir

func take_damage(amount: int):
	if is_dead: return
	health -= amount
	update_ui()
	
	if health <= 0:
		die()

func update_ui():
	if health_label:
		health_label.text = "Health: " + str(health)

func die():
	is_dead = true
	input_enabled = false
	velocity = Vector2.ZERO
	if anim.sprite_frames.has_animation("death"):
		anim.play("death")
	# Tady jen zastavíme fyziku, zbytek vyřeší TutorialManager
	set_physics_process(false)
