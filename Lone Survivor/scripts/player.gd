extends CharacterBody2D

const SPEED := 100.0          
const JUMP_VELOCITY := -350.0
const ATTACK_COOLDOWN := 0.5 

var health := 5 
var input_enabled := true
var is_dead := false
var attack_timer := 0.0 

@onready var sprite = $AnimatedSprite2D
@onready var attack_area = get_node_or_null("AttackArea") 
# ODKAZ NA NOVOU DETEKČNÍ ZÓNU:
@onready var hrac_detekce = $HracDetekce 

func _ready():
	# Propojíme signál z té Area2D, kterou jsi právě přidal pod hráče
	if hrac_detekce:
		hrac_detekce.area_entered.connect(_on_area_entered)

func _physics_process(delta):
	if is_dead:
		return
	if not input_enabled:
		return
	if attack_timer > 0:
		attack_timer -= delta
	if not is_on_floor():
		velocity += get_gravity() * delta

	# --- SKOK A SESKOK ---
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() and Input.is_action_pressed("ui_down"):
			position.y += 5 
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if attack_area:
			attack_area.scale.x = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("attack") and attack_timer <= 0:
		perform_attack()

	update_animations(direction)
	move_and_slide()

# ... (funkce update_animations, perform_attack a take_damage zůstávají stejné) ...

func update_animations(direction):
	if sprite.animation == "fist" and sprite.is_playing():
		return
	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

func perform_attack():
	if not attack_area: return
	attack_timer = ATTACK_COOLDOWN 
	sprite.play("fist") 
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.is_in_group("enemy") and target.has_method("take_damage"):
			target.take_damage(1)

func take_damage(amount: int):
	if is_dead: return
	health -= amount
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	if health <= 0:
		die()

# --- OPRAVENÁ DETEKCE ---
func _on_area_entered(area: Area2D):
	if area.is_in_group("water"):
		die()

func die():
	if is_dead: return 
	is_dead = true
	input_enabled = false
	velocity = Vector2.ZERO
	set_physics_process(false) 
	sprite.play("death") 
	
	var death_menu = get_tree().current_scene.find_child("DeathMenu")
	if death_menu:
		death_menu.show_death()
