extends Node2D

const LEVEL_LIMIT = 120
const isStationary = true

@onready var HEALTH = $Stats.HEALTH
@onready var STRENGTH = $Stats.STRENGTH
@onready var INVI_DURATION = $Stats.INVI_DURATION
@onready var MASS = $Stats.MASS
@onready var BYPASSES_INVIS = $Stats.BYPASSES_INVIS
@onready var AWARENESS = $Stats.AWARENESS
@onready var ATTACKTIMER = $Stats.ATTACKTIMER

var ySpeed = 0
var invitimer = 0
var knockedBack = false
var freed = false
var attacking = false
var attackTimer = ATTACKTIMER

@onready var sprite = $AnimatedSprite2D
@onready var RayDown = $RaycastDown
@onready var player = $/root/Game/Player
@onready var hurtArea = $HurtArea

func _ready() -> void:
	attackTimer = ATTACKTIMER
	RayDown.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	hurtArea.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if position.y > LEVEL_LIMIT:
		queue_free()
	#$Label.text = "HP: " + str(int(HEALTH))
	if HEALTH > 0:
		if AWARENESS <= 0:
			attacking = true
		elif abs(position.x - player.position.x) <= AWARENESS:
			if attackTimer > 0.0:
				attackTimer -= delta
			elif sprite.animation != "Attack":
				sprite.play("Attack")
				attacking = true
		
		if invitimer > 0:
			invitimer -= delta
		
		if not knockedBack:
			if sprite.animation == "Hurt":
				sprite.play("Idle")
		else:
			sprite.play("Hurt")
		
		if RayDown.is_colliding() and RayDown.get_collider() != player:
			if sprite.animation == "Hurt" and sprite.frame > 0:
				knockedBack = false
			if ySpeed >= 0:
				ySpeed = 0
		else:
			ySpeed += 10
		
	else:
		if sprite.animation != "Dead":
			sprite.play("Dead")
		if not freed:
			ySpeed = -250
			freed = true
		ySpeed += 10
	position.y += delta * ySpeed

func knockback(playerPos,strength) -> void:
	if HEALTH > 0:
		knockedBack = true
		ySpeed = -25 * strength


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "Attack":
		attackTimer = ATTACKTIMER
		attacking = false
		sprite.play("Idle")
