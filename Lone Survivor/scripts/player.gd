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

func _physics_process(delta):
	if not input_enabled or is_dead:
		return

	# Odpočítávání cooldownu
	if attack_timer > 0:
		attack_timer -= delta

	# Gravitace
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Skok
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Pohyb
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if attack_area:
			attack_area.scale.x = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# ÚTOK
	if Input.is_action_just_pressed("attack") and attack_timer <= 0:
		perform_attack()

	# Animace
	update_animations(direction)

	move_and_slide()

func update_animations(direction):
	# Pokud právě probíhá animace úderu, nebudeme ji ničím přerušovat
	if sprite.animation == "fist" and sprite.is_playing():
		return

	# Jinak hrajeme klasiku podle stavu
	if not is_on_floor():
		sprite.play("jump")
	elif direction != 0:
		sprite.play("walk")
	else:
		sprite.play("idle")

func perform_attack():
	if not attack_area:
		return
	
	attack_timer = ATTACK_COOLDOWN 
	sprite.play("fist") # Spustí animaci pěsti
	
	# Zásah nepřítele
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.is_in_group("enemy") and target.has_method("take_damage"):
			target.take_damage(1)

func take_damage(amount: int):
	health -= amount
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func die():
	if is_dead: return # Pojistka, aby se to nespouštělo víckrát
	
	is_dead = true
	input_enabled = false
	sprite.play("death") # Přehraje animaci postavy (pokud máš)
	
	# --- TADY JE TO PROPOJENÍ S DEATH MENU ---
	# Najde v aktuální scéně uzel s názvem "DeathMenu"
	var death_menu = get_tree().current_scene.find_child("DeathMenu")
	
	if death_menu:
		death_menu.show_death()
	else:
		# Pokud bys ho zapomněl přidat do scény, tak aspoň restartuj, ať to nezamrzne
		print("Chyba: DeathMenu nebylo nalezeno v hlavní scéně!")
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
