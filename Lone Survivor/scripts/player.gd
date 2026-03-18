extends CharacterBody2D

const SPEED := 100.0          
const JUMP_VELOCITY := -350.0
const ATTACK_COOLDOWN := 0.5 

var health := 5 
var input_enabled := true
var is_dead := false
var attack_timer := 0.0 
var lever_in_range: Area2D = null 

@onready var sprite = $AnimatedSprite2D
@onready var attack_area = get_node_or_null("AttackArea") 
@onready var jump_sound = $JumpSound
@onready var punch_sound = $PunchSound
@onready var detection_voda = $HracDetekce        
@onready var detection_lever = $InterakceDetekce  
@onready var health_ui = get_tree().root.find_child("HealthGUI", true, false)

func _ready():
	add_to_group("player")
	
	if health_ui:
		health_ui.update_health(health)
	
	if detection_voda:
		if not detection_voda.area_entered.is_connected(_on_water_entered):
			detection_voda.area_entered.connect(_on_water_entered)
		
	if detection_lever:
		if not detection_lever.area_entered.is_connected(_on_lever_entered):
			detection_lever.area_entered.connect(_on_lever_entered)
		if not detection_lever.area_exited.is_connected(_on_lever_exited):
			detection_lever.area_exited.connect(_on_lever_exited)

func _physics_process(delta):
	if is_dead or not input_enabled:
		velocity = Vector2.ZERO
		return

	if attack_timer > 0:
		attack_timer -= delta

	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() and Input.is_action_pressed("ui_down"):
			position.y += 5 
		elif is_on_floor():
			velocity.y = JUMP_VELOCITY
			if jump_sound:
				jump_sound.play()

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite.flip_h = direction < 0
		if attack_area:
			attack_area.scale.x = -1 if direction < 0 else 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if Input.is_action_just_pressed("pull"):
		if lever_in_range:
			lever_in_range.toggle()

	if Input.is_action_just_pressed("attack"):
		if attack_timer <= 0:
			perform_attack()

	update_animations(direction)
	move_and_slide()

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
	
	if punch_sound:
		punch_sound.play()
	
	var targets = attack_area.get_overlapping_bodies()
	for target in targets:
		if target.is_in_group("enemy") and target.has_method("take_damage"):
			target.take_damage(1)

func take_damage(amount: int):
	if is_dead: return
	health -= amount
	
	if health_ui:
		health_ui.update_health(health)
	
	sprite.modulate = Color(1, 0, 0)
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1)
	
	if health <= 0:
		die()

func _on_water_entered(area: Area2D):
	if area.is_in_group("water"):
		die() 

func _on_lever_entered(area: Area2D):
	if area.is_in_group("lever"):
		lever_in_range = area

func _on_lever_exited(area: Area2D):
	if area == lever_in_range:
		lever_in_range = null

func die():
	if is_dead: return 
	is_dead = true
	input_enabled = false
	velocity = Vector2.ZERO
	set_physics_process(false) 
	sprite.play("death") 
	
	var death_menu = get_tree().root.find_child("DeathMenu", true, false)
	if death_menu:
		death_menu.show_death()
