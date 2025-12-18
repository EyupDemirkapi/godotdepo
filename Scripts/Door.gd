extends StaticBody2D


@onready var exterior = $/root/Game/Modulate/ExteriorTileMap
@onready var interior = $/root/Game/Modulate/InteriorTileMap
@onready var player = $/root/Game/Modulate/Player
@onready var sprite = $AnimatedSprite2D
var isInterior = true
var turned = false

func _ready() -> void:
	interior.modulate.a = 1
	exterior.modulate.a = 0

func _physics_process(delta:float) -> void:
	#iceri disari cikma
	if sprite.animation != "Idle":
		if not turned:
			turned = true
			isInterior = not isInterior
		if sprite.frame < 4:
			player.scale *= 0.8
		elif sprite.frame < 8:
			if isInterior:
				alphaTween(true)
			else:
				alphaTween(false)
			if player.scale < Vector2.ONE:
				player.scale /= 0.8
			else:
				player.scale = Vector2.ONE
		else:
			turned = false
			player.scale = Vector2.ONE #nolur nolmaz
			collisionChange(1)
			collisionChange(2)
			sprite.play("Idle")
	
	
	if Input.is_action_just_pressed("GroundSwap") and $Area2D.overlaps_body(player) and sprite.animation == "Idle":
		if isInterior:
			sprite.play("Outside")
		else:
			sprite.play("Inside")

func alphaTween(isToInt)-> void:
	get_tree().create_tween().tween_property(interior,"modulate:a",int(isToInt),0.1)
	get_tree().create_tween().tween_property(exterior,"modulate:a",int(not isToInt),0.1)


func collisionChange(layerValue) -> void:
	player.set_collision_layer_value(layerValue, not player.get_collision_layer_value(layerValue))
	player.set_collision_mask_value(layerValue, not player.get_collision_mask_value(layerValue))
