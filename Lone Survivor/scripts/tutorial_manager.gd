extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	WATER_WARNING,
	CLIMB_HELP,     # Text u lian
	DONE,
	GAME_OVER
}

const DEATH_Y := 730
const WATER_X_START := 450.0 
const WATER_X_END := 800.0    # Kdy naskočí text o lianách (kousek za vodou)
const FINAL_X_POS := 1400.0   # Kdy tutorial úplně zmizí (za lianami)

var step := TutorialStep.ALIVE
var player: CharacterBody2D
var death_menu: Control

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	death_menu = $"../CanvasLayer2/UI_Root/DeathMenu"
	if player == null: return
	update_text()

func _process(_delta):
	if player == null or step == TutorialStep.GAME_OVER: return

	# KONTROLA SMRTI
	if player.global_position.y >= DEATH_Y or player.is_dead:
		freeze_game_at_death()
		return

	match step:
		TutorialStep.ALIVE:
			check_alive()
		TutorialStep.MOVE:
			check_move()
		TutorialStep.JUMP:
			check_jump()
		TutorialStep.WATER_WARNING:
			check_water_proximity()
		TutorialStep.CLIMB_HELP:
			check_climb_progress()

func update_text():
	match step:
		TutorialStep.ALIVE:
			label.visible = true
			label.text = "... what happened? My head... I need to get up."
		TutorialStep.MOVE:
			label.text = "Move: ARROW KEYS"
		TutorialStep.JUMP:
			label.text = "The path is blocked. \nJump: SPACEBAR"
		TutorialStep.WATER_WARNING:
			label.visible = true
			label.text = "The swamp looks deep. \nDon't fall in!"
		TutorialStep.CLIMB_HELP:
			label.visible = true
			label.text = "I need to get higher. \nJump through the vines!"
		TutorialStep.DONE:
			label.text = "Objective: Find the extraction point."
			var tween = create_tween()
			tween.tween_interval(3.0)
			tween.tween_property(label, "modulate:a", 0.0, 1.5)
			await tween.finished
			label.visible = false
		TutorialStep.GAME_OVER:
			label.visible = false

func check_alive():
	await get_tree().create_timer(2.0).timeout
	if step == TutorialStep.ALIVE:
		step = TutorialStep.MOVE
		update_text()

func check_move():
	if abs(player.velocity.x) > 0.1:
		await get_tree().create_timer(1.0).timeout
		if step == TutorialStep.MOVE:
			step = TutorialStep.JUMP
			update_text()

func check_jump():
	if player.global_position.x > WATER_X_START:
		step = TutorialStep.WATER_WARNING
		update_text()

func check_water_proximity():
	# Text o lianách naskočí dřív - hned jak hráč překoná propast
	if player.global_position.x > WATER_X_END:
		step = TutorialStep.CLIMB_HELP
		update_text()

func check_climb_progress():
	# Teď neřešíme výšku Y, ale jen to, že hráč postoupil dál v levelu
	if player.global_position.x > FINAL_X_POS:
		step = TutorialStep.DONE
		update_text()

func freeze_game_at_death():
	step = TutorialStep.GAME_OVER
	label.visible = false
	player.input_enabled = false
	player.velocity = Vector2.ZERO
	if death_menu: death_menu.show_menu()
