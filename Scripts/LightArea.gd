extends Area2D

var isPlayerInLight = false
var lightTimer = 0.0
@onready var player = $/root/Game/Modulate/Player
@onready var moon = $/root/Game/Camera2D/Moon
@onready var sun = $/root/Game/Camera2D/Sun
@onready var heartGenerator = $/root/Game/Camera2D/UI/HeartUIGenerator

func _ready() -> void:
	set_collision_layer_value(get_parent().get_tileset().get_physics_layer_collision_mask(0),true)
	set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_mask(0),true)

func _physics_process(delta: float) -> void:
	#$Label.text = str(isPlayerInLight and not player.isInNoLightArea)
	if get_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_mask(0)) != player.get_collision_layer_value(get_parent().get_tileset().get_physics_layer_collision_mask(0)):
		isPlayerInLight = false
		lightTimer = 0.0
	#$Label.text = "Light Timer: {0}".format([str(lightTimer)])
	if (not player.isInNoLightArea) and isPlayerInLight and player.HEALTH > 0 and sun.position.y < moon.position.y:
		lightTimer -= delta
		if lightTimer <= 0:
			player.HEALTH -= 1
			heartGenerator.generateHearts(player.HEALTH)
			player.knockback(0,3.5)
			lightTimer = lerp(6,1,-sun.position.y/60)
			if lightTimer > 6:
				lightTimer = 6
			elif lightTimer < 1:
				lightTimer = 1

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		isPlayerInLight = true
		lightTimer = 0.5
func _on_body_exited(body: Node2D) -> void:
	if body == player:
		isPlayerInLight = false
		lightTimer = 0.0
