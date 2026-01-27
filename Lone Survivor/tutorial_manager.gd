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

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"
@onready var death_menu: Control = $"../CanvasLayer/DeathMenu"

func _ready():
	player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("TutorialManager: Player not found!")
		return

	update_text()

func _process(delta):
	if player == null:
		return

	# SMRT PÁDEM
	if player.global_position.y >= DEATH_Y:
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
			label.text = "Great! You're ready 👍"
		TutorialStep.GAME_OVER:
			label.visible = true
			label.text = "YOU DIED"
			label.modulate.a = 0.0
			var tween := create_tween()
			tween.tween_property(label, "modulate:a", 1.0, 0.5)

func check_alive():
	await get_tree().create_timer(1.5).timeout
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
		await get_tree().create_timer(1.0).timeout
		label.visible = false

func freeze_game_at_death():
	if step == TutorialStep.GAME_OVER:
		return

	step = TutorialStep.GAME_OVER

	player.velocity = Vector2.ZERO
	player.input_enabled = false
	player.set_physics_process(false)

	death_menu.show_menu()

	update_text()
