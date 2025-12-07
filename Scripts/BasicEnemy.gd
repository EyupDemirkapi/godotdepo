extends Node2D

const LEVEL_LIMIT = 120

@onready var SPEED = $Stats.SPEED
@onready var HEALTH = $Stats.HEALTH
@onready var STRENGTH = $Stats.STRENGTH
@onready var INVI_DURATION = $Stats.INVI_DURATION
@onready var MASS = $Stats.MASS

var xSpeed = 0
var ySpeed = 0
var direction = -1
var invitimer = 0
var knockedBack = false
var freed = false

@onready var sprite = $AnimatedSprite2D
@onready var RayLeft = $RaycastLeft
@onready var RayRight = $RaycastRight
@onready var RayDown = $RaycastDown
@onready var player = $/root/Game/Player
@onready var hurtArea = $HurtArea

func _ready() -> void:
	RayLeft.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	RayRight.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	RayDown.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	hurtArea.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if position.y > LEVEL_LIMIT:
		queue_free()
	#$Label.text = "HP: " + str(int(HEALTH))
	if HEALTH > 0:
		if invitimer > 0:
			invitimer -= delta
		
		position.x += direction * delta * xSpeed
		
		if not knockedBack:
			sprite.play("Walk")
			xSpeed = SPEED
			if RayLeft.is_colliding() and RayLeft.get_collider() != player:
				direction = 1
			elif RayRight.is_colliding() and RayRight.get_collider() != player:
				direction = -1
			if RayDown.is_colliding():
				ySpeed = 0
			else:
				ySpeed += 10
		else:
			sprite.play("Hurt")
			if RayDown.is_colliding() and RayDown.get_collider() != player:
				knockedBack = false
			else:
				ySpeed += 10
		
		if direction > 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
			
		
	else:
		sprite.play("Dead")
		if not freed:
			ySpeed = -250
			freed = true
		ySpeed += 10
	position.y += delta * ySpeed

func knockback(playerPos,strength) -> void:
	if HEALTH > 0:
		knockedBack = true
		xSpeed = playerPos * strength
		ySpeed = -25 * strength
