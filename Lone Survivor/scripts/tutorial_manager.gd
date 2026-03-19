extends Node

enum TutorialStep {
	ALIVE,
	MOVE,
	JUMP,
	ATTACK,
	WAITING_FOR_LEVER,
	LEVER_HINT,
	ONE_WAY_INFO,
	HEAL_HINT,
	DONE,
	GAME_OVER
}

var step := TutorialStep.ALIVE
var player: CharacterBody2D
var current_text_id := 0

@onready var label: Label = $"../CanvasLayer/TutorialUI/TutorialText"

func _ready():
	player = get_tree().get_first_node_in_group("player")
	update_text()

func advance_to(new_step: TutorialStep):
	if new_step > step:
		step = new_step
		update_text()

func _process(_delta):
	if player == null or step == TutorialStep.GAME_OVER: 
		return

	if player.is_dead:
		step = TutorialStep.GAME_OVER
		if label: label.visible = false
		return

	match step:
		TutorialStep.ALIVE: check_alive()
		TutorialStep.MOVE: check_move()
		TutorialStep.JUMP: check_jump()
		TutorialStep.ATTACK: check_attack()
		TutorialStep.WAITING_FOR_LEVER: check_lever_proximity()
		TutorialStep.ONE_WAY_INFO: check_one_way_input()

func update_text():
	if label == null: return
	
	current_text_id += 1
	var local_id = current_text_id
	
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 0.2)
	await tween.finished
	
	match step:
		TutorialStep.ALIVE: label.text = "... what happened? My head..."
		TutorialStep.MOVE: label.text = "Move: ARROW KEYS"
		TutorialStep.JUMP: label.text = "The path is blocked. \nJump: SPACEBAR"
		TutorialStep.ATTACK: label.text = "Attack: K"
		TutorialStep.LEVER_HINT: label.text = "Pull the lever: E"
		TutorialStep.ONE_WAY_INFO: label.text = "Pass through platforms: \nARROW DOWN + SPACE"
		TutorialStep.HEAL_HINT: label.text = "Collect the Medkit to heal!"
		TutorialStep.DONE: label.text = "Objective: Find the extraction point."
		TutorialStep.WAITING_FOR_LEVER: return

	label.modulate.a = 1.0
	
	await get_tree().create_timer(4.0).timeout
	
	if local_id == current_text_id and step != TutorialStep.GAME_OVER:
		var tween_out = create_tween()
		tween_out.tween_property(label, "modulate:a", 0.0, 1.0)
		await tween_out.finished
		
		if step == TutorialStep.LEVER_HINT:
			advance_to(TutorialStep.ONE_WAY_INFO)
		elif step == TutorialStep.HEAL_HINT:
			advance_to(TutorialStep.DONE)

func check_alive():
	await get_tree().create_timer(2.0).timeout
	advance_to(TutorialStep.MOVE)

func check_move():
	if abs(player.velocity.x) > 0.1:
		advance_to(TutorialStep.JUMP)

func check_jump():
	if not player.is_on_floor():
		advance_to(TutorialStep.ATTACK)

func check_attack():
	if Input.is_action_just_pressed("attack") or Input.is_key_pressed(KEY_K):
		step = TutorialStep.WAITING_FOR_LEVER
		var tween = create_tween()
		tween.tween_property(label, "modulate:a", 0.0, 0.5)

func check_lever_proximity():
	if player.get("lever_in_range") != null:
		advance_to(TutorialStep.LEVER_HINT)

func check_one_way_input():
	var down = Input.is_key_pressed(KEY_DOWN) or Input.is_action_pressed("ui_down")
	var jump = Input.is_key_pressed(KEY_SPACE) or Input.is_action_just_pressed("ui_accept")
	
	if down and jump:
		advance_to(TutorialStep.HEAL_HINT)
