extends Camera2D
var rect
var nightcolor = Color(0.045, 0.008, 0.131, 1.0)
var daycolor = Color(0.289, 0.693, 0.868, 1.0)
var color = nightcolor
var lerpcolor
var day = false
var daytimer = 0
@onready var moon = $Moon
@onready var sun = $Sun
const DAYLENGTH = 100
const YVALUE = 60
var alphatimer

func _physics_process(delta: float) -> void:
	#arkaplan boyutu
	rect = Rect2(DisplayServer.screen_get_position() - DisplayServer.screen_get_size()/2,DisplayServer.screen_get_size())
	#ayla güneşin alfasını hesaplamak için
	alphatimer = ((daytimer - 0.5)**2)*-(2.0**2) + 1
	
	#gün gece geçişi
	if color.r <= nightcolor.r:
		dayTransition(true)
	elif color.r >= daycolor.r:
		dayTransition(false)
	
	daytimer += delta / DAYLENGTH
	
	moon.modulate.a = lerp(0,1,alphatimer*2)
	sun.modulate.a = lerp(0,1,alphatimer*2)
	
	if day:
		dayProgress(nightcolor)
	else:
		dayProgress(daycolor)
	queue_redraw()
	#$Label.text = "r: " + str(color.r) + "g: " + str(color.g) + "b: " + str(color.b)
func _draw() -> void:
	draw_rect(rect,color)
	
func dayTransition(toDay) -> void:
		sun.position.x *= -1
		moon.position.x *= -1
		day = not toDay
		daytimer = 0
		lerpcolor = color
		
func dayProgress(toColor) -> void:
	moon.position.y = lerp(YVALUE*int(day) - YVALUE*2*int(not day),YVALUE*int(not day) - YVALUE*2*int(day),daytimer)
	sun.position.y = lerp(YVALUE*int(not day) - YVALUE*2*int(day),YVALUE*int(day) - YVALUE*2*int(not day),daytimer)
	color = lerpcolor.lerp(toColor,daytimer)
