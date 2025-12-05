extends Camera2D
var rect = Rect2(Vector2(-191,-109),DisplayServer.window_get_size())
var color = Color(0.025, 0.081, 0.181, 1.0)
var lerpcolor
var day = false
var daytimer = 0
@onready var moon = $Moon
@onready var sun = $Sun
const DAYLENGTH = 10
const YVALUE = 60
var alphatimer

func _physics_process(delta: float) -> void:
	alphatimer = ((daytimer - 0.5)**2)*-4 + 1
	if color.r <= 0.026:
		sun.position.x *= -1
		moon.position.x *= -1
		day = false
		daytimer = 0
		lerpcolor = color
	elif color.r >= 0.288:
		sun.position.x *= -1
		moon.position.x *= -1
		day = true
		daytimer = 0
		lerpcolor = color
	daytimer += delta / DAYLENGTH
	moon.modulate.a = lerp(0,1,alphatimer*2)
	sun.modulate.a = lerp(0,1,alphatimer*2)
	if day:
		moon.position.y = lerp(YVALUE,-YVALUE*2,daytimer)
		sun.position.y = lerp(-YVALUE*2,YVALUE,daytimer)
		color = lerpcolor.lerp(Color(0.025, 0.081, 0.181, 1.0),daytimer)
	else:
		moon.position.y = lerp(-YVALUE*2,YVALUE,daytimer)
		sun.position.y = lerp(YVALUE,-YVALUE*2,daytimer)
		color = lerpcolor.lerp(Color(0.289, 0.693, 0.868, 1.0),daytimer)
	queue_redraw()
	#$Label.text = "r: " + str(color.r) + "g: " + str(color.g) + "b: " + str(color.b)
func _draw() -> void:
	draw_rect(rect,color)
	
