extends Area2D


func _ready() -> void:
	set_collision_layer_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
	set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_layer(0),true)
