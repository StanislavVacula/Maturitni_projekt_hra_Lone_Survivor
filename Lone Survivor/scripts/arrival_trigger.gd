extends Area2D

@onready var label = $FinalText

func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("player"):
		label.modulate.a = 1.0 

func _on_body_exited(body):
	if body.is_in_group("player"):
		label.modulate.a = 0.0 
