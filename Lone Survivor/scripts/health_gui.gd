extends Control

@onready var hearts_container = $HBoxContainer

func update_health(current_health: int):
	if not hearts_container:
		return
		
	var hearts = hearts_container.get_children()
	
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
