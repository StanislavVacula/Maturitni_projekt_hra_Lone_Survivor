extends Node

enum TutorialStep {
	MOVE,
	JUMP,
	DONE
}

var step := TutorialStep.MOVE
var player: CharacterBody2D

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("TutorialManager: Player nebyl nalezen!")
		return

	update_text()

func _process(delta):
	match step:
		TutorialStep.MOVE:
			check_move()
		TutorialStep.JUMP:
			check_jump()

func update_text():
	match step:
		TutorialStep.MOVE:
			label.visible = true
			label.text = "Použij ← → pro pohyb"
		TutorialStep.JUMP:
			label.text = "Stiskni SPACE pro skok"
		TutorialStep.DONE:
			label.text = "Super! Jsi připraven 👍"

func check_move():
	# hráč se skutečně pohybuje
	if abs(player.velocity.x) > 0:
		step = TutorialStep.JUMP
		update_text()

func check_jump():
	if not player.is_on_floor():
		step = TutorialStep.DONE
		update_text()

		await get_tree().create_timer(1.0).timeout
		label.visible = false
