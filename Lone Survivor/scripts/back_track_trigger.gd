extends Area2D

@onready var warning_label = $"../CanvasLayer/WarningLabel"

func _ready():
	warning_label.modulate.a = 0
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		show_warning()

func show_warning():
	var tween = create_tween()
	tween.tween_property(warning_label, "modulate:a", 1.0, 0.5)
	tween.tween_interval(2.0)
	tween.tween_property(warning_label, "modulate:a", 0.0, 0.5)
