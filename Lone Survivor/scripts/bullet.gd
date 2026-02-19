extends Area2D # Hlavně zkontroluj, že máš nahoře Area2D!

@export var speed := 600.0
@export var lifetime := 3.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	# Časovač na smazání náboje zůstává stejný
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	if direction == Vector2.ZERO:
		return

	# TADY JE TA ZMĚNA:
	# Area2D nemá "velocity", takže musíme měnit pozici přímo.
	# Vzorec: nová_pozice = stará_pozice + směr * rychlost * čas_snímku
	position += direction * speed * delta

# Nezapomeň mít tento signál připojený v editoru (uzel Bullet -> uzel Area2D -> Signals)
func _on_body_entered(body):
	if body.is_in_group("enemy"):
		# Tady zatím nic (pokud střílí nepřítel do nepřítele), 
		# nebo sem dej logiku pro zabití nepřítele hráčem
		return

	if body.is_in_group("player"):
		if body.has_method("take_damage"):
			body.take_damage(1)
		queue_free()
	else:
		# Pokud narazí do zdi (TileMap)
		queue_free()
