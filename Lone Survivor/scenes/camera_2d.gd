extends Camera2D

@export var player: Node2D         # sem si v editoru přetáhneš Player node
@export var follow_speed: float = 3.0  # rychlost sledování (čím víc, tím rychlejší pohyb kamery)

func _ready() -> void:
	make_current()  # tato kamera bude aktivní

func _process(delta: float) -> void:
	if player:
		# plynulé sledování hráče
		global_position = global_position.lerp(player.global_position, delta * follow_speed)
