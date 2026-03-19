extends Area2D

const HEAL_AMOUNT := 1

@onready var sfx_pickup = $PickupSound

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if body.has_method("heal"):
			var result = body.heal(HEAL_AMOUNT)
			if result == true:
				queue_free()
