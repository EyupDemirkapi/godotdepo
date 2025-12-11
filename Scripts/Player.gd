extends CharacterBody2D

@onready var SPEED = $Stats.SPEED
@onready var DASH_SPEED = $Stats.DASH_SPEED
@onready var DASH_DURATION = $Stats.DASH_DURATION
@onready var JUMP_HEIGHT = $Stats.JUMP_HEIGHT
@onready var JUMP_BUFFER = $Stats.JUMP_BUFFER
@onready var HEALTH = $Stats.HEALTH
@onready var STRENGTH = $Stats.STRENGTH
@onready var INVI_DURATION = $Stats.INVI_DURATION

var walkfinished = true
var jumpfinished = true
var attackfinished = true
var animFinished = false
var knockedBack = false

var isInNoLightArea = false

var freed = false

var inputDir
var xSpeed = 0.0
var ySpeed = 0.0

var invitimer = 0

@onready var sprite = $AnimatedSprite2D

var jumpBuffer = 0
var attackTimer = 0

func _physics_process(delta: float) -> void:
	#$Label.text = "X velocity: "+str(velocity.x) + "\nY velocity: " + str(velocity.y)	
	#$Label.text = str(HEALTH)
	#saldırma
	if HEALTH > 0:
		if invitimer > 0:
			invitimer -= delta
		if not knockedBack:
		
			#sağ sol hareket
			inputDir = Input.get_axis("MoveLeft","MoveRight")
			if inputDir != 0:
				if attackfinished:
					xSpeed = SPEED * inputDir
				if jumpfinished and attackfinished:
					sprite.play("Walk")
				walkfinished = false
				if inputDir < 0:
					sprite.flip_h = true
				else:
					sprite.flip_h = false
			#input gelmezse yavaş yavaş durma
			elif attackfinished:
				if abs(xSpeed) > 1:
					xSpeed /= 1.25
				else:
					xSpeed=0
			
			attack()
			if attackTimer > 0 and sprite.scale >= Vector2.ONE:
				attackTimer -= delta
			
			#zıplama
			if is_on_ceiling() and ySpeed < 0:
				ySpeed = 0
		else:
			if abs(xSpeed) > 1:
				xSpeed /= 1.05
			else:
				xSpeed=0
			if is_on_floor() and ySpeed > 0:
				knockedBack = false
				sprite.play("Idle")
		if is_on_floor():
			if not knockedBack:
				jumpBuffer = JUMP_BUFFER
				if sprite.animation == "JumpLoop" or (sprite.animation == "AttackEnd" and animFinished):
					attackfinished = true
					sprite.play("Land")
				jump(0, jumpBuffer)
			if ySpeed >= 0:
				ySpeed = 0
		else:
			if not knockedBack:
				if jumpBuffer > 0:
					jumpBuffer -= delta
					jump(150, jumpBuffer)
				if sprite.animation == "AttackEnd" and animFinished:
					attackfinished = true
					sprite.play("JumpLoop")
					jumpfinished = false
			ySpeed += 10
			
	#kapıya girerken hareketin engellenmesi
	if sprite.scale < Vector2.ONE:
		invitimer = INVI_DURATION
		velocity = Vector2.ZERO
	else:
		velocity = Vector2(xSpeed,ySpeed)
	move_and_slide()
	
	#animasyon
	if HEALTH > 0:
		if walkfinished and jumpfinished and attackfinished and not knockedBack:
			sprite.play("Idle")
		if sprite.animation == "Walk" and animFinished:
			walkfinished = true
		if sprite.animation == "Land" and animFinished:
			jumpfinished = true
			sprite.play("Idle")
		if sprite.animation == "JumpStart" and animFinished:
			sprite.play("JumpLoop")
		if sprite.animation == "AttackStart" and animFinished:
			sprite.play("AttackLoop")
		if sprite.animation == "AttackLoop" and attackTimer <= 0:
			sprite.play("AttackEnd")
	else:
		sprite.play("Dead")
		if not freed:
			xSpeed = 0
			ySpeed = -250
			freed = true
			$CollisionShape2D.queue_free()
		ySpeed += 10
		if position.y > 1000:
			get_tree().reload_current_scene()
	if animFinished:
		animFinished = false


func jump(bufferAmount, currentBuffer) -> void:
	if Input.is_action_pressed("Jump"):
		jumpfinished = false
		if attackfinished:
			sprite.play("JumpStart")
			ySpeed -= JUMP_HEIGHT + bufferAmount / (int(15 * currentBuffer)+1)
		else:
			ySpeed -= JUMP_HEIGHT*2/3 + bufferAmount / (int(15 * currentBuffer)+1)
		jumpBuffer = 0

func attack() -> void:
	if Input.is_action_pressed("Attack") and attackfinished:
		attackfinished = false
		sprite.play("AttackStart")
		attackTimer = DASH_DURATION
	if not attackfinished:
		if sprite.flip_h:
			xSpeed = -DASH_SPEED
		else:
			xSpeed = DASH_SPEED

func knockback(playerPos,strength) -> void:
	if HEALTH > 0 and invitimer <= 0:
		attackfinished = true
		jumpfinished = true
		knockedBack = true
		sprite.play("Dead")
		xSpeed = playerPos * strength
		ySpeed = -25 * strength

func _on_animated_sprite_2d_animation_finished() -> void:
	animFinished = true
func take_damage(amount: int) -> void:
	if invitimer > 0:
		return

	HEALTH -= amount
	invitimer = INVI_DURATION
	sprite.play("Dead")

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "NoLightArea":
		isInNoLightArea = true

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "NoLightArea":
		isInNoLightArea = false
