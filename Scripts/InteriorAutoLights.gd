extends Node2D

@onready var lightArea = get_parent().get_child(1)
@onready var tilemap = get_parent()
@export var LIGHT_LENGTH = 32
var windows
#var source:TileSetAtlasSource = tile_set.get_source(0) as TileSetAtlasSource
#var rect = source.get_tile_texture_region(Vector2(1,0))
#var image:Image = source.get_texture().get_image()
#var tile_image:Image = image.get_region(rect)
var tex:ImageTexture
func _ready() -> void:
	lightArea.add_child(tilemap.get_node(^"CollisionShape2D"))
	windows = tilemap.get_used_cells_by_id(0,0,Vector2(1,0))
	#for i in tile_image.get_height():
	#	for i2 in tile_image.get_width():
	#		if tile_image.get_pixel(i2,i) == Color.TRANSPARENT:
	#			tile_image.set_pixel(i2,i,Color.WHITE)
	#		else:
	#			tile_image.set_pixel(i2,i,Color.TRANSPARENT)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#queue_redraw()
	pass

func _draw() -> void:
	var start = 16
	tex = ImageTexture.create_from_image(Image.load_from_file("res://Sprites/Light.png"))
	for vec:Vector2 in windows:
		for i in range(-start,LIGHT_LENGTH):
			tex.set_size_override(Vector2(13+(i+start)/2,22))
			var worldPos = tilemap.map_to_local(vec) + Vector2(-8-(i+start)/4,i)
			draw_texture(tex,worldPos,Color(1,1,1,0.033))#-((i+start)/(LIGHT_LENGTH+start))*0.033))
