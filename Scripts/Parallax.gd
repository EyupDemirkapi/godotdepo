extends TileMap
class_name ParallaxDisplay

@onready var player = $/root/Game/Player
const Z_INDEX_MAX = 5.0 # bu değeri x kabul edersek -x daima kamerayı takip eden, +x ise kameradan maksimum uzaklaşma eğiliminde olan katman oluyor
						# 0 oyuncunun bulunduğu katmanlar

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = ParallaxMethodVector(self,player.position)
static func ParallaxMethodFloat(node,lerpValue:float) -> float:
	return lerp(lerpValue,-lerpValue,(node.z_index + Z_INDEX_MAX) / (Z_INDEX_MAX * 2))
static func ParallaxMethodVector(node,lerpValue:Vector2) -> Vector2:
	return lerp(lerpValue,-lerpValue,(node.z_index + Z_INDEX_MAX) / (Z_INDEX_MAX * 2))
