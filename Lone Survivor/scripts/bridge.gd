extends AnimatableBody2D

signal bridge_activated

@onready var sprite = $AnimatedSprite2D
@onready var col_vertical = $CollisionVertical
@onready var col_horizontal = $CollisionHorizontal

func _ready():
	visible = true 
	sprite.play("default") 
	col_vertical.disabled = false
	col_horizontal.disabled = true

func appear():
	if sprite.animation == "active": return 
	
	sprite.play("active")
	
	col_vertical.set_deferred("disabled", true)
	col_horizontal.set_deferred("disabled", false)
	
	bridge_activated.emit()
	print("Most spadl dolů!")
