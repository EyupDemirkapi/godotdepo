extends Camera2D

var rect = Rect2(DisplayServer.screen_get_position() - DisplayServer.screen_get_size()/2,DisplayServer.screen_get_size())
var nightcolor = Color(0.045, 0.008, 0.131, 1.0)
var daycolor = Color(0.289, 0.693, 0.868, 1.0)
var color = nightcolor
var lerpcolor

var day = false
var daytimer = 0

@onready var moon = $Moon
@onready var sun = $Sun
@onready var player = $/root/Game/Modulate/Player
@onready var modulateIngame = $/root/Game/Modulate

const DAYLENGTH = 100
const YVALUE = 60

var alphatimer

const CAMERA_BOT_LIMIT = 0.0
const CAMERA_TOP_LIMIT = -100.0


func _physics_process(delta: float) -> void:
	#W$Label.text = "Alpha Timer: {0}\nDay timer: {1}".format([alphatimer,daytimer])
	if player.position.y >= CAMERA_BOT_LIMIT or player.position.y <= CAMERA_TOP_LIMIT:
		position.x = ParallaxDisplay.ParallaxMethodFloat(self,player.position.x)
	else:
		position = ParallaxDisplay.ParallaxMethodVector(self,player.position)
	#arkaplan boyutu
	rect = Rect2(DisplayServer.screen_get_position() - DisplayServer.screen_get_size()/2,DisplayServer.screen_get_size())
	#ayla güneşin alfasını hesaplamak için
	#alphatimer = ((daytimer*0.5 - 0.5)**8)*-(2.0**8) + 1
	#alphatimer = sin((daytimer-0.5)*PI)/2 + 0.5
	alphatimer = 2*((daytimer/2)-(sin(2*PI*daytimer))/(4*PI))
	#gün gece geçişi
	if color.r <= nightcolor.r:
		dayTransition(true)
	elif color.r >= daycolor.r:
		dayTransition(false)
	if moon.modulate.a <= 0 and sun.modulate.a <= 0:
		sun.position.x *= -1
		moon.position.x *= -1
	moon.modulate.a = lerp(1,0,alphatimer)
	sun.modulate.a = lerp(0,1,alphatimer)
	modulateIngame.modulate = lerp(Color.DIM_GRAY,Color.WHITE,daytimer)
	
	dayProgress(not day,delta)
	queue_redraw()
	#$Label.text = "r: " + str(color.r) + "g: " + str(color.g) + "b: " + str(color.b)
func _draw() -> void:
	draw_rect(rect,color)
	
func dayTransition(toDay) -> void:
	day = not toDay
	
func dayProgress(isDay,delta) -> void:
	moon.position.y = lerp(-YVALUE,YVALUE,alphatimer)
	sun.position.y = lerp(YVALUE,-YVALUE,alphatimer)
	color = lerp(nightcolor,daycolor,daytimer)
	daytimer += (2*int(isDay) - 1)*delta/ DAYLENGTH
