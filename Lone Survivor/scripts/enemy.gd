extends CharacterBody2D

const SPEED = 0
const CHANGE_TIME = 2.0
const SHOOT_COOLDOWN = 0.6
const RAY_LENGTH = 300

var direction := 1
var timer := 0.0
var chasing := false
var shoot_timer := 0.0
var player: Node2D = null

@export var bullet_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var muzzle: Marker2D = $Muzzle

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	raycast.target_position = Vector2(RAY_LENGTH, 0)
	raycast.enabled = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	chasing = false

	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("player"):
			chasing = true

	if chasing and player:
		velocity.x = 0

		direction = sign(player.global_position.x - global_position.x)
		if direction == 0:
			direction = 1

		shoot_timer -= delta
		if shoot_timer <= 0:
			shoot()
			shoot_timer = SHOOT_COOLDOWN
	else:
		velocity.x = direction * SPEED
		timer += delta
		if timer >= CHANGE_TIME:
			direction *= -1
			timer = 0.0

	sprite.flip_h = direction < 0
	raycast.target_position = Vector2(RAY_LENGTH * direction, 0)

	# otočení muzzle podle směru
	muzzle.position.x = abs(muzzle.position.x) * direction

	move_and_slide()

func shoot():
	if bullet_scene == null:
		push_warning("❌ Bullet scene není nastavená!")
		return

	print("SHOOT CALLED")

	var bullet = bullet_scene.instantiate()

	# pozice
	bullet.global_position = muzzle.global_position

	# směr střely
	bullet.direction = direction

	# přidání do scény
	get_tree().current_scene.add_child(bullet)
