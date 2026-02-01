extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	DONE,
	GAME_OVER
}

const DEATH_Y := 730

var step := TutorialStep.ALIVE
var player: CharacterBody2D
var death_menu: Control

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	death_menu = $"../CanvasLayer2/UI_Root/DeathMenu"

	if player == null:
		push_error("TutorialManager: Player not found!")
		return

	if death_menu == null:
		push_error("TutorialManager: DeathMenu not found!")
		return

	update_text()

func _process(delta):
	if player == null:
		return

	# SMRT PÁDEM
	if player.global_position.y >= DEATH_Y and step != TutorialStep.GAME_OVER:
		freeze_game_at_death()
		return

	match step:
		TutorialStep.ALIVE:
			check_alive()
		TutorialStep.MOVE:
			check_move()
		TutorialStep.JUMP:
			check_jump()

func update_text():
	match step:
		TutorialStep.ALIVE:
			label.visible = true
			label.text = "I'm alive! Let's get moving!"
		TutorialStep.MOVE:
			label.text = "Use ← → to move"
		TutorialStep.JUMP:
			label.text = "Press SPACE to jump"
		TutorialStep.DONE:
			label.visible = false
		TutorialStep.GAME_OVER:
			label.visible = false

# ---------- TUTORIAL KROKY ----------

func check_alive():
	await get_tree().create_timer(1.2).timeout
	if step == TutorialStep.ALIVE:
		step = TutorialStep.MOVE
		update_text()

func check_move():
	if abs(player.velocity.x) > 0:
		step = TutorialStep.JUMP
		update_text()

func check_jump():
	if not player.is_on_floor():
		step = TutorialStep.DONE
		update_text()

# ---------- SMRT ----------

func freeze_game_at_death():
	step = TutorialStep.GAME_OVER

	player.velocity = Vector2.ZERO
	player.input_enabled = false
	player.set_physics_process(false)

	death_menu.show_menu()
