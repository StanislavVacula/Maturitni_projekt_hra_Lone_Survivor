extends Control

@export var next_level_path: String = ""
@export_multiline var diary_text: String = ""

@onready var rich_text_label = $RichTextLabel
@onready var continue_button = $ContinueButton
@onready var type_sound = $TypeSound

var current_char = 0

func _ready():
	rich_text_label.text = diary_text
	rich_text_label.visible_characters = 0
	continue_button.hide()
	continue_button.pressed.connect(_on_continue_pressed)
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.08
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	if current_char < diary_text.length():
		current_char += 1
		rich_text_label.visible_characters = current_char
		
		if diary_text[current_char - 1] != " ":
			type_sound.play()
	else:
		continue_button.show()

func _on_continue_pressed():
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
