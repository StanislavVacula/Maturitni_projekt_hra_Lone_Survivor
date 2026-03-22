extends CharacterBody2D

const SPEED := 50.0
const RAY_LENGTH := 400.0
const PATROL_DURATION := 2.0

@export var bullet_scene: PackedScene
@export var shoot_interval: float = 3.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D
@onready var muzzle: Marker2D = $Muzzle
@onready var sfx_shoot = $ShootSound
@onready var sfx_pain = $EnemyPain

var health := 3 
var shoot_timer := 0.0
var patrol_timer := 0.0
var player: Node2D = null
var direction := -1.0 

func _ready():
	add_to_group("enemy")
	raycast.add_exception(self)
	raycast.collision_mask = 2 
	patrol_timer = PATROL_DURATION
	
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	if shoot_timer > 0:
		shoot_timer -= delta

	var can_see_player = false
	var dir_to_player = Vector2.ZERO

	if player != null and not player.is_dead:
		var dist_to_player = global_position.distance_to(player.global_position)
		
		if dist_to_player < RAY_LENGTH:
			dir_to_player = (player.global_position - global_position).normalized()
			
			if (dir_to_player.x > 0 and direction > 0) or (dir_to_player.x < 0 and direction < 0) or velocity.x == 0:
				raycast.target_position = to_local(player.global_position)
				raycast.force_raycast_update()
				
				if raycast.is_colliding():
					var collider = raycast.get_collider()
					if collider and collider.is_in_group("player"):
						can_see_player = true

	if can_see_player:
		velocity.x = 0
		handle_combat(dir_to_player)
	else:
		patrol_timer -= delta
		if patrol_timer <= 0 or is_on_wall():
			direction *= -1.0
			patrol_timer = PATROL_DURATION
		
		velocity.x = direction * SPEED
		muzzle.position.x = abs(muzzle.position.x) * direction

	_update_animations()
	move_and_slide()

func _update_animations():
	if velocity.x == 0:
		if sprite.animation != "idle":
			sprite.play("idle")
	else:
		if sprite.animation != "walk":
			sprite.play("walk")
		sprite.flip_h = direction < 0

func handle_combat(dir: Vector2):
	sprite.flip_h = dir.x < 0
	muzzle.position.x = abs(muzzle.position.x) * sign(dir.x)
	
	if shoot_timer <= 0:
		shoot(dir)
		shoot_timer = shoot_interval

func shoot(dir: Vector2):
	if sfx_shoot:
		sfx_shoot.play()

	if bullet_scene == null: 
		return
		
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = muzzle.global_position
	bullet.direction = dir.normalized()
	bullet.rotation = dir.angle()

func take_damage(amount: int):
	health -= amount
	
	if sfx_pain:
		sfx_pain.play()
		
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(5, 5, 5), 0.1)
	tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.1)
	
	if health <= 0:
		die()

func die():
	queue_free()
