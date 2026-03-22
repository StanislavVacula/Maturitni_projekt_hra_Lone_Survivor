extends Area2D

@export_file("*.tscn") var next_level_path: String

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		if next_level_path != "":
			get_tree().change_scene_to_file(next_level_path)
		else:
			print("Chyba: Není nastavena cesta k dalšímu levelu!")
