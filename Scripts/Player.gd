extends CharacterBody2D

var walkfinished = true
var jumpfinished = true
var inputDir
var xSpeed = 0.0
var ySpeed = 0.0
@onready var sprite = $AnimatedSprite2D
@onready var checker = $GroundChecker
var jumpBuffer = 0

func _physics_process(delta: float) -> void:
	#$Label.text = "X velocity: "+str(velocity.x) + "\nY velocity: " + str(velocity.y)	
	
	#hareket
	if is_on_ceiling() and ySpeed < 0:
		ySpeed = 0
	if is_on_floor():
		jumpBuffer = 0.2
		if sprite.animation == "jump":
			sprite.play("land")
		ySpeed = 0
		if Input.is_action_pressed("Jump"):
			jumpBuffer = 0
			jumpfinished = false
			sprite.play("jumpstart")
			ySpeed -= 310
	else:
		if jumpBuffer > 0:
			jumpBuffer -= delta
			if Input.is_action_pressed("Jump"):
				jumpBuffer = 0
				jumpfinished = false
				sprite.play("jumpstart")
				ySpeed -= 310
		ySpeed += 10
	inputDir = Input.get_axis("MoveLeft","MoveRight")
	if inputDir != 0:
		xSpeed = 225 * inputDir
		if jumpfinished:
			sprite.play("walk")
		walkfinished = false
		if inputDir < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		if abs(xSpeed) > 1:
			xSpeed /= 1.25
		else:
			xSpeed=0
	if sprite.scale < Vector2.ONE:
		velocity = Vector2.ZERO
	else:
		velocity = Vector2(xSpeed,ySpeed)
	move_and_slide()
	
	
	#animasyon
	if walkfinished and jumpfinished:
		sprite.play("idle")
	if sprite.animation == "walk" and sprite.frame >= 6:
		walkfinished = true
	if sprite.animation == "land" and sprite.frame >= 4:
		jumpfinished = true
		sprite.play("idle")
	if sprite.animation == "jumpstart" and sprite.frame >= 4:
			sprite.play("jump")
