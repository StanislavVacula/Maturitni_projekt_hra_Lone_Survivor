extends Area2D

@onready var sfx_pickup = $PickupSound
@onready var sprite = $Sprite2D 

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		if body.has_method("heal"):
			body.heal(body.max_health)
		sfx_pickup.play()
		sprite.visible = false
		$CollisionShape2D.set_deferred("disabled", true)
		await sfx_pickup.finished
		queue_free()
