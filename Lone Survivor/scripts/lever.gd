extends Area2D

signal activated

var is_on := false
@onready var sprite = $AnimatedSprite2D

func _ready():
	add_to_group("lever")
	sprite.play("off") # Ensure your animation name is "off"

func toggle():
	if is_on: return # Only allow one-time activation
	
	is_on = true
	sprite.play("on") # Ensure your animation name is "on"
	emit_signal("activated")
	print("Lever activated!")
