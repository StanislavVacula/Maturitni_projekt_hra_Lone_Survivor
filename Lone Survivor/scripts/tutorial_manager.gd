extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	ATTACK,
	WATER_WARNING,
	CLIMB_HELP,
	LEVER_HINT,
	DONE,
	GAME_OVER
}

const WATER_X_START := 450.0 
const FINAL_X_POS := 1400.0   

var step := TutorialStep.ALIVE
var player: CharacterBody2D

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
	# Automatické připojení na signál mostu
	var bridge = get_tree().root.find_child("Bridge", true, false)
	if bridge:
		bridge.bridge_activated.connect(_on_bridge_activated)
		
	update_text()

func _process(_delta):
	if player == null or step == TutorialStep.GAME_OVER: 
		return

	if player.is_dead:
		step = TutorialStep.GAME_OVER
		if label: label.visible = false
		return

	# Priorita nápovědy u páčky
	if player.lever_in_range != null and step != TutorialStep.DONE:
		if step != TutorialStep.LEVER_HINT:
			step = TutorialStep.LEVER_HINT
			update_text()
	elif player.lever_in_range == null and step == TutorialStep.LEVER_HINT:
		step = TutorialStep.CLIMB_HELP
		update_text()

	match step:
		TutorialStep.ALIVE: check_alive()
		TutorialStep.MOVE: check_move()
		TutorialStep.JUMP: check_jump()
		TutorialStep.ATTACK: check_attack()
		TutorialStep.WATER_WARNING: check_water_proximity()
		TutorialStep.CLIMB_HELP: check_climb_progress()

func update_text():
	if label == null: return
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	
	await tween.finished # Počkáme na zmizení textu
	
	match step:
		TutorialStep.ALIVE: label.text = "... what happened? My head..."
		TutorialStep.MOVE: label.text = "Move: ARROW KEYS"
		TutorialStep.JUMP: label.text = "The path is blocked. \nJump: SPACEBAR"
		TutorialStep.ATTACK: label.text = "Attack: K"
		TutorialStep.WATER_WARNING: label.text = "The swamp is deep. Don't fall in!"
		TutorialStep.CLIMB_HELP: label.text = "I need to get higher. Use the vines!"
		TutorialStep.LEVER_HINT: label.text = "Pull the lever by pressing: E"
		TutorialStep.DONE: label.text = "Objective: Find the extraction point."

	var tween_in = create_tween()
	tween_in.tween_property(label, "modulate:a", 1.0, 0.5) 

func check_alive():
	await get_tree().create_timer(3.0).timeout
	if step == TutorialStep.ALIVE:
		step = TutorialStep.MOVE
		update_text()

func check_move():
	if abs(player.velocity.x) > 0.1:
		await get_tree().create_timer(1.5).timeout
		if step == TutorialStep.MOVE:
			step = TutorialStep.JUMP
			update_text()

func check_jump():
	if not player.is_on_floor():
		await get_tree().create_timer(1.0).timeout
		if step == TutorialStep.JUMP:
			step = TutorialStep.ATTACK
			update_text()

func check_attack():
	if Input.is_action_just_pressed("attack"):
		await get_tree().create_timer(1.0).timeout
		if step == TutorialStep.ATTACK:
			step = TutorialStep.WATER_WARNING
			update_text()

func check_water_proximity():
	if player.global_position.x > WATER_X_START:
		step = TutorialStep.CLIMB_HELP
		update_text()

func check_climb_progress():
	pass

# Voláno signálem z mostu
func _on_bridge_activated():
	step = TutorialStep.DONE
	update_text()
