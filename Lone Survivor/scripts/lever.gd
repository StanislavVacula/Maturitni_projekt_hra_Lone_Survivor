extends Area2D

var is_on := false
@onready var sprite = $AnimatedSprite2D

func _ready():
	add_to_group("lever")
	sprite.play("off") 

func toggle():
	if is_on: return 
	
	is_on = true
	sprite.play("on") 
	print("Páka aktivována!")
