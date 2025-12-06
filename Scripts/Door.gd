extends StaticBody2D


@onready var exterior = $/root/Game/ExteriorTileMap
@onready var interior = $/root/Game/InteriorTileMap
@onready var player = $/root/Game/Player
@onready var sprite = $AnimatedSprite2D
var isInterior = true
var turned = false

func _ready() -> void:
	interior.modulate.a = 1
	exterior.modulate.a = 0

func _physics_process(delta:float) -> void:
	#iceri disari cikma
	if sprite.animation == "anim":
		if not turned:
			turned = true
			isInterior = not isInterior
		if sprite.frame < 4:
			$/root/Game/Player/AnimatedSprite2D.scale *= 0.8
		elif sprite.frame < 8:
			if isInterior:
				get_tree().create_tween().tween_property(interior,"modulate:a",1.0,0.1)
				get_tree().create_tween().tween_property(exterior,"modulate:a",0.0,0.1)
			else:
				get_tree().create_tween().tween_property(exterior,"modulate:a",1.0,0.1)
				get_tree().create_tween().tween_property(interior,"modulate:a",0.0,0.1)
			if $/root/Game/Player/AnimatedSprite2D.scale < Vector2.ONE:
				$/root/Game/Player/AnimatedSprite2D.scale /= 0.8
			else:
				$/root/Game/Player/AnimatedSprite2D.scale = Vector2.ONE
		else:
			turned = false
			$/root/Game/Player/AnimatedSprite2D.scale = Vector2.ONE #nolur nolmaz
			collisionChange(1)
			collisionChange(2)
			sprite.play("idle")
	
	
	if Input.is_action_just_pressed("GroundSwap") and $Area2D.overlaps_body(player):
		sprite.play("anim")


func collisionChange(layerValue) -> void:
	player.set_collision_layer_value(layerValue, not player.get_collision_layer_value(layerValue))
	player.set_collision_mask_value(layerValue, not player.get_collision_mask_value(layerValue))
