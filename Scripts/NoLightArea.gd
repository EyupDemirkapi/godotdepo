extends Area2D

@onready var player = $/root/Game/Modulate/Player

func _ready() -> void:
	set_collision_layer_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)



func _on_body_entered(body: Node2D) -> void:
	if body == player:
		player.isInNoLightArea = true


func _on_body_exited(body: Node2D) -> void:
	if body == player:
		player.isInNoLightArea = false
