extends Control

@export_multiline var diary_text: String = ""

@onready var rich_text_label = $RichTextLabel
@onready var continue_button = $ContinueButton
@onready var type_sound = $TypeSound

var current_char = 0

func _ready():
	rich_text_label.text = diary_text
	rich_text_label.visible_characters = 0
	continue_button.hide()
	
	if not continue_button.pressed.is_connected(_on_continue_pressed):
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
			if type_sound:
				type_sound.play()
	else:
		continue_button.show()

func _on_continue_pressed():
	var result = get_tree().change_scene_to_file("res://scenes/tutorial.tscn")
