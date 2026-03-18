extends Area2D

@export var bridge_node: AnimatableBody2D 

var is_on := false
@onready var sprite = $AnimatedSprite2D
@onready var sfx_pull = $LeverPull

func _ready():
	add_to_group("lever")

func toggle():
	if is_on: return 
	
	is_on = true
	
	if sfx_pull:
		sfx_pull.play()
		
	if sprite: 
		sprite.play("on")
	
	if bridge_node:
		bridge_node.appear()
