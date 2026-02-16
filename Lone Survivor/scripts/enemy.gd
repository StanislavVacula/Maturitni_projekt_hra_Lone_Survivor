extends CharacterBody2D

const SHOOT_COOLDOWN := 1.0
const RAY_LENGTH := 400.0

@export var bullet_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var muzzle: Marker2D = $Muzzle

var shoot_timer := 0.0
var player: Node2D = null

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

	raycast.enabled = true

func _physics_process(delta):
	if player == null:
		return

	# směr k hráči
	var dir_to_player = (player.global_position - global_position).normalized()

	# raycast směr
	raycast.target_position = dir_to_player * RAY_LENGTH

	# otočení enemáka
	if dir_to_player.x != 0:
		sprite.flip_h = dir_to_player.x < 0

		# správné překlápění muzzle
		muzzle.position.x = abs(muzzle.position.x) * sign(dir_to_player.x)

	# cooldown
	shoot_timer -= delta

	# detekce hráče
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("player"):
			if shoot_timer <= 0:
				shoot(dir_to_player)
				shoot_timer = SHOOT_COOLDOWN


func shoot(dir: Vector2):
	if bullet_scene == null:
		push_warning("Bullet scene není nastavená!")
		return

	print("SHOOT")

	var bullet = bullet_scene.instantiate()

	# 🔥 KLÍČOVÉ ŘÁDKY:
	bullet.global_transform = muzzle.global_transform
	bullet.direction = dir.normalized()

	# přidání do root scény (ne jako child enemáka!)
	get_tree().current_scene.add_child(bullet)
