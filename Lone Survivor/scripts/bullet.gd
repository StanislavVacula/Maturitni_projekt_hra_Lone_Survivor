extends CharacterBody2D

@export var speed: float = 500.0
var direction: int = 1   # -1 = doleva, 1 = doprava

func _ready():
	# debug
	print("BULLET SPAWNED, direction =", direction)

func _physics_process(delta):
	velocity.x = direction * speed
	move_and_slide()
