extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	ATTACK,
	WATER_WARNING,
	CLIMB_HELP,
	DONE,
	GAME_OVER
}

# Už nepotřebujeme DEATH_Y, smrt řeší Area2D (voda)
const WATER_X_START := 450.0 
const FINAL_X_POS := 1400.0   

var step := TutorialStep.ALIVE
var player: CharacterBody2D
var death_menu: Node

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	death_menu = get_tree().current_scene.find_child("DeathMenu")
	
	if player == null: 
		print("Tutorial Error: Player not found!")
		return
		
	update_text()

func _process(_delta):
	if player == null or step == TutorialStep.GAME_OVER: 
		return

	# Tutorial jen kontroluje, jestli už hráč není mrtvý (z jakéhokoli důvodu)
	if player.is_dead:
		freeze_game_at_death()
		return

	match step:
		TutorialStep.ALIVE:
			check_alive()
		TutorialStep.MOVE:
			check_move()
		TutorialStep.JUMP:
			check_jump()
		TutorialStep.ATTACK:
			check_attack()
		TutorialStep.WATER_WARNING:
			check_water_proximity()
		TutorialStep.CLIMB_HELP:
			check_climb_progress()

func update_text():
	if label == null: return
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	
	match step:
		TutorialStep.ALIVE:
			label.text = "... what happened? My head... I need to get up."
		TutorialStep.MOVE:
			label.text = "Move: ARROW KEYS"
		TutorialStep.JUMP:
			label.text = "The path is blocked. \nJump: SPACEBAR"
		TutorialStep.ATTACK:
			label.text = "I feel danger nearby. \nAttack: K"
		TutorialStep.WATER_WARNING:
			label.text = "The swamp looks deep. \nDon't fall in!"
		TutorialStep.CLIMB_HELP:
			label.text = "I need to get higher. \nJump through the vines!"
		TutorialStep.DONE:
			label.text = "Objective: Find the extraction point."
		TutorialStep.GAME_OVER:
			label.visible = false
			return

	tween.tween_property(label, "modulate:a", 1.0, 0.5) 
	
	if step == TutorialStep.DONE:
		await get_tree().create_timer(4.0).timeout
		var fade_out = create_tween()
		fade_out.tween_property(label, "modulate:a", 0.0, 1.5)

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
	if player.global_position.x > FINAL_X_POS:
		step = TutorialStep.DONE
		update_text()

func freeze_game_at_death():
	if step == TutorialStep.GAME_OVER: return
	step = TutorialStep.GAME_OVER
	if label: label.visible = false
	
	if death_menu: 
		death_menu.show_death()
