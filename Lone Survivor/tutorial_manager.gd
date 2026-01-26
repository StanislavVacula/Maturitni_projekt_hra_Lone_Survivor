extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	DONE,
	GAME_OVER
}

var step := TutorialStep.ALIVE
var player: CharacterBody2D

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		push_error("TutorialManager: Player not found!")
		return

	update_text()

func _process(delta):
	if player == null:
		return

	
	if player.global_position.y > 500:
		match step:
			TutorialStep.ALIVE:
				check_alive()
			TutorialStep.MOVE:
				check_move()
			TutorialStep.JUMP:
				check_jump()
	else:
		if step != TutorialStep.GAME_OVER:
			step = TutorialStep.GAME_OVER
			update_text()
			player.input_enabled = false
			# Restart po 3 sekundách
			restart_after_delay(3.0)

func update_text():
	match step:
		TutorialStep.ALIVE:
			label.visible = true
			label.text = "I'm ALIVE! Let's get moving!"
		TutorialStep.MOVE:
			label.text = "Use ← → to move"
		TutorialStep.JUMP:
			label.text = "Press SPACE to jump"
		TutorialStep.DONE:
			label.text = "Great! You're ready 👍"
		TutorialStep.GAME_OVER:
			label.text = "YOU ARE DEAD, BETTER LUCK NEXT TIME SON"
			label.visible = true
			# Jednoduchý fade-in přes Tween
			label.modulate.a = 0
			var tween = create_tween()
			tween.tween_property(label, "modulate:a", 1.0, 1.0)

func check_alive():
	var timer = get_tree().create_timer(1.5)
	await timer.timeout
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
		var timer = get_tree().create_timer(1.0)
		await timer.timeout
		label.visible = false

func restart_after_delay(seconds):
	# jednoduchý async restart bez inline func
	var timer = get_tree().create_timer(seconds)
	await timer.timeout
	get_tree().reload_curre
