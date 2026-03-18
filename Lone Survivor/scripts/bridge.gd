extends AnimatableBody2D

signal bridge_activated

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var is_active = false

func _ready():
	rotation_degrees = 0
	sprite.play("default")

func appear():
	if is_active: return 
	is_active = true
	
	print("Most padá!")
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", -90.0, 1.2).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	await tween.finished

	bridge_activated.emit()
