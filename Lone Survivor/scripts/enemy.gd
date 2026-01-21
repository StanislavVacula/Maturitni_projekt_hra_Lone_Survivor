extends CharacterBody2D

# ====== KONSTANTY ======
const SPEED = 50.0
const CHANGE_TIME = 2.0
const SHOOT_COOLDOWN = 0.6
const RAY_LENGTH = 300

# ====== PROMĚNNÉ ======
var direction := 1
var timer := 0.0
var chasing := false
var shoot_timer := 0.0
var player: Node2D = null

# ====== SCÉNY ======
@export var bullet_scene: PackedScene

# ====== NODE REFERENCES ======
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var muzzle: Marker2D = $Muzzle

# ====== READY ======
func _ready():
	# najdeme hráče ve skupině "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	# nastavení raycastu
	raycast.target_position = Vector2(RAY_LENGTH, 0)
	raycast.enabled = true

# ====== PHYSICS PROCESS ======
func _physics_process(delta: float) -> void:
	# gravitace
	if not is_on_floor():
		velocity += get_gravity() * delta

	# ====== DETEKCE HRÁČE ======
	chasing = false
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("player"):
			chasing = true

	# ====== CHOVÁNÍ ======
	if chasing and player:
		# zastaví se a střílí
		velocity.x = 0

		direction = sign(player.global_position.x - global_position.x)
		if direction == 0:
			direction = 1

		shoot_timer -= delta
		if shoot_timer <= 0:
			shoot()
			shoot_timer = SHOOT_COOLDOWN
	else:
		# hlídka
		velocity.x = direction * SPEED
		timer += delta
		if timer >= CHANGE_TIME:
			direction *= -1
			timer = 0.0

	# ====== SPRITE + RAYCAST + MUZZLE ======
	sprite.flip_h = direction < 0

	raycast.target_position = Vector2(RAY_LENGTH * direction, 0)
	muzzle.position.x = abs(muzzle.position.x) * direction

	# ====== POHYB ======
	move_and_slide()

# ====== STŘELBA ======
func shoot():
	if bullet_scene == null:
		push_warning("Bullet scene není nastavená!")
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_position = muzzle.global_position
	bullet.direction = direction

	get_parent().add_child(bullet)
