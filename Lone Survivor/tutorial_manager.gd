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
	# Opravená cesta k death menu podle tvé struktury
	death_menu = $"../CanvasLayer2/UI_Root/DeathMenu"

	if player == null:
		push_error("TutorialManager: Player not found!")
		return

	update_text()

func _process(_delta):
	if player == null or step == TutorialStep.GAME_OVER:
		return

	# KONTROLA SMRTI (Pád do propasti NEBO ztráta životů)
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

func check_alive():
	# await v _process může být zrádný, ale pro tutorial ok
	if step == TutorialStep.ALIVE:
		# Jednoduchý timer, aby text nezmizel hned
		await get_tree().create_timer(1.2).timeout
		if step == TutorialStep.ALIVE: # Kontrola, jestli mezitím neumřel
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

func freeze_game_at_death():
	step = TutorialStep.GAME_OVER
	
	# Vypneme UI tutorialu
	label.visible = false
	
	# Pro jistotu zastavíme hráče, pokud ho trefil náboj
	player.input_enabled = false
	player.velocity = Vector2.ZERO
	
	# Zobrazíme tvoje menu
	if death_menu:
		death_menu.show_menu() # Volá tvoji funkci v DeathMenu skriptu
	else:
		push_error("TutorialManager: Nemůžu najít DeathMenu pro zobrazení!")
