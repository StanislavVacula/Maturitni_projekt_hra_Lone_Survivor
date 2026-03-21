extends Area2D

@onready var sfx_pickup = $PickupSound

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if body.has_method("heal"):
			var result = body.heal(body.max_health)
			if result == true:
				queue_free()
