extends Area2D

@onready var collision_shape = $CollisionShape2D

func _process(_delta):
	var overlapping_bodies = get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body.is_in_group("player") or body.name == "player":
			var win_menu = get_tree().root.find_child("WinMenu", true, false)
			if win_menu:
				collision_shape.disabled = true
				win_menu.show_win()
