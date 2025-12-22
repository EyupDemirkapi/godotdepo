extends Node2D

var lightArea
var lightCollider
var lightColliderShape = ConvexPolygonShape2D.new()
@onready var tilemap = get_parent()
@export var LIGHT_LENGTH = 32
var windows
#var source:TileSetAtlasSource = tile_set.get_source(0) as TileSetAtlasSource
#var rect = source.get_tile_texture_region(Vector2(1,0))
#var image:Image = source.get_texture().get_image()
#var tile_image:Image = image.get_region(rect)
var tex:ImageTexture
func _ready() -> void:
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
		lightArea = load("res://Scenes/LightArea.tscn").instantiate()
		lightCollider = CollisionShape2D.new()
		lightColliderShape.set_point_cloud(PackedVector2Array([Vector2(5,0),Vector2(10,0),Vector2(20,48),Vector2(-5,48)]))
		lightCollider.set_shape(lightColliderShape)
		lightArea.add_child(lightCollider)
		lightArea.position = tilemap.map_to_local(vec) + Vector2(-8,-8)
		tilemap.add_child(lightArea)
		for i in range(-start,LIGHT_LENGTH):
			tex.set_size_override(Vector2(13+(i+start)/2,22))
			var worldPos = tilemap.map_to_local(vec) + Vector2(-8-(i+start)/4,i)
			draw_texture(tex,worldPos,Color(1,1,1,0.033))#-((i+start)/(LIGHT_LENGTH+start))*0.033))
