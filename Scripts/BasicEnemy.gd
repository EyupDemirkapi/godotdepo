extends Node2D

@onready var SPEED = $Stats.SPEED
@onready var HEALTH = $Stats.HEALTH
@onready var STRENGTH = $Stats.STRENGTH
var ySpeed = 0
var direction = -1
@onready var sprite = $AnimatedSprite2D
@onready var RayLeft = $RaycastLeft
@onready var RayRight = $RaycastRight
@onready var RayDown = $RaycastDown
@onready var player = $/root/Game/Player

func _ready() -> void:
	RayLeft.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	RayRight.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	RayDown.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	position.x += direction * delta * SPEED
	
	if RayLeft.is_colliding() and RayLeft.get_collider() != player:
		direction = 1
	elif RayRight.is_colliding() and RayRight.get_collider() != player:
		direction = -1
	if RayDown.is_colliding():
		ySpeed = 0
	else:
		ySpeed += 10
		position.y += delta * ySpeed
	
	if direction > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
