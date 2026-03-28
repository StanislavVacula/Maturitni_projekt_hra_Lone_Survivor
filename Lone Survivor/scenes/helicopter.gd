extends StaticBody2D

@onready var label = get_node("Label")

func _on_area_2d_body_entered(body):
	label.modulate.a = 1.0

func _on_area_2d_body_exited(body):
	label.modulate.a = 0.0
