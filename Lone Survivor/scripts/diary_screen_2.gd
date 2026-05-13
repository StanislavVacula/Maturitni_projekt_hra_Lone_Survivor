extends Control

@export var next_level_path: String = ""
@export_multiline var diary_text: String = ""

@onready var rich_text_label = $RichTextLabel
@onready var continue_button = $ContinueButton
@onready var type_sound = $TypeSound

var current_char = 0
var is_finished = false 

func _ready():
	rich_text_label.text = diary_text
	rich_text_label.visible_characters = 0
	continue_button.hide()
	
	if not continue_button.pressed.is_connected(_on_continue_pressed):
		continue_button.pressed.connect(_on_continue_pressed)
	
	var timer = Timer.new()
	timer.name = "TypeTimer" 
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
		_finish_typing()

func _finish_typing():
	if is_finished: return 
	is_finished = true
	current_char = diary_text.length()
	rich_text_label.visible_characters = current_char
	
	if has_node("TypeTimer"):
		get_node("TypeTimer").stop()
	
	continue_button.show()
	continue_button.grab_focus() 

func _input(event):
	if event.is_action_pressed("ui_accept"): 
		if not is_finished:
			_finish_typing()
			get_viewport().set_input_as_handled()

func _on_continue_pressed():
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
