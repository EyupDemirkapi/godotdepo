extends Node2D

@onready var HEALTH_UP = $Stats.HEALTH_UP
@onready var MAX_HEALTH_UP = $Stats.MAX_HEALTH_UP
@onready var STRENGTH_UP = $Stats.STRENGTH_UP
@onready var SCORE_UP = $Stats.SCORE_UP

@onready var player = $/root/Game/Modulate/Player
@onready var heartGenerator = $/root/Game/Camera2D/UI/HeartUIGenerator

var image:Image
var tex:ImageTexture
var texsizer = 18.0
var increasesize = false

func _ready() -> void:
	$Area2D.set_collision_layer_value(get_parent().get_tileset().get_physics_layer_collision_mask(0),true)
	$Area2D.set_collision_mask_value(get_parent().get_tileset().get_physics_layer_collision_mask(0),true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if texsizer < 16:
		increasesize = true
	elif texsizer > 18:
		increasesize = false
	if increasesize:
		texsizer += delta*2
	else:
		texsizer -= delta*2
	queue_redraw()

func _draw()->void:
	image = $AnimatedSprite2D.sprite_frames.get_frame_texture("default",$AnimatedSprite2D.frame).get_image()
	for i1 in range(image.get_width()):
		for i2 in range(image.get_height()):
			if image.get_pixel(i1,i2).a == 0:
				pass
			else:
				image.set_pixel(i1,i2,Color(0.212,0.718,1.0,1-((texsizer-16)/2)))
	tex = ImageTexture.create_from_image(image)
	tex.set_size_override(Vector2i(18,18))
	draw_texture(tex,Vector2(-9,-9))


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		player.HEALTH += HEALTH_UP
		player.MAX_HEALTH += MAX_HEALTH_UP
		if player.HEALTH > player.MAX_HEALTH:
			player.HEALTH = player.MAX_HEALTH
		if HEALTH_UP > 0 or MAX_HEALTH_UP > 0:
			heartGenerator.generateHearts(player.HEALTH)
		player.STRENGTH += STRENGTH_UP
		#player.SCORE += SCORE_UP
		
		queue_free()
