extends CharacterBody2D

# ====== KONSTANTY ======
const SPEED = 0.0           # rychlost pohybu
const CHANGE_TIME = 2.0       # po kolika sekundách změní směr hlídky

# ====== PROMĚNNÉ ======
var direction := 1            # 1 = doprava, -1 = doleva
var timer := 0.0
var chasing := false
var player: Node2D = null     # reference na hráče

# ====== NODE REFERENCES ======
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D

# ====== READY ======
func _ready():
	# najdeme hráče podle skupiny "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

# ====== PHYSICS PROCESS ======
func _physics_process(delta: float) -> void:
	# GRAVITACE
	if not is_on_floor():
		velocity += get_gravity() * delta

	# DETEKCE HRÁČE PŘES RAYCAST
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider.is_in_group("player"):
			chasing = true
		else:
			chasing = false
	else:
		chasing = false

	# POHYB
	if chasing and player:
		# jdi směrem k hráči
		direction = sign(player.global_position.x - global_position.x)
		velocity.x = direction * SPEED
	else:
		# hlídkuj tam a zpět
		velocity.x = direction * SPEED
		timer += delta
		if timer >= CHANGE_TIME:
			direction *= -1
			timer = 0.0

	# OTOČENÍ SPRITE
	sprite.flip_h = direction < 0

	# OTÁČENÍ RAYCASTU PODLE SMĚRU
	raycast.cast_to.x = direction  

	# POHYB S KOLIZÍ
	move_and_slide()
