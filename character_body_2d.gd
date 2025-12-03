extends CharacterBody2D

var walkfinished = true
var jumpfinished = true
#var onDoor = false
var onDoor = true
var xSpeed = 0.0
var ySpeed = 0.0

func _physics_process(delta: float) -> void:
	$Label.text = "X velocity: "+str(velocity.x) + "\nY velocity: " + str(velocity.y)
	#iceri disari cikma
	if Input.is_action_just_pressed("GroundSwap") and onDoor:
		set_collision_layer_value(1, not get_collision_layer_value(1))
		set_collision_layer_value(2, not get_collision_layer_value(2))
		set_collision_mask_value(1, not get_collision_mask_value(1))
		set_collision_mask_value(2, not get_collision_mask_value(2))
		$/root/game/ExteriorTileMap.visible = not $/root/game/ExteriorTileMap.visible
		$/root/game/InteriorTileMap.visible = not $/root/game/InteriorTileMap.visible
	
	
	#hareket
	if is_on_ceiling() and ySpeed < 0:
		ySpeed = 0
	if is_on_floor():
		if $AnimatedSprite2D.animation == "jump":
			$AnimatedSprite2D.play("land")
		ySpeed = 0
		if Input.is_action_just_pressed("Jump"):
			jumpfinished = false
			$AnimatedSprite2D.play("jumpstart")
			ySpeed -= 300
	else:
		ySpeed += 10
	if Input.is_action_pressed("MoveLeft") and abs(xSpeed) < 225:
		if jumpfinished:
			$AnimatedSprite2D.play("walk")
		walkfinished = false
		$AnimatedSprite2D.flip_h = true
		xSpeed = -225
	elif Input.is_action_pressed("MoveRight") and abs(xSpeed) < 225:
		if jumpfinished:
			$AnimatedSprite2D.play("walk")
		walkfinished = false
		$AnimatedSprite2D.flip_h = false
		xSpeed = 225
	else:
		if abs(xSpeed) > 1:
			xSpeed /= 1.25
		else:
			xSpeed=0
	velocity = Vector2(xSpeed,ySpeed)
	move_and_slide()
	
	
	#animasyon
	if walkfinished and jumpfinished:
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "walk" and $AnimatedSprite2D.frame >= 6:
		walkfinished = true
	if $AnimatedSprite2D.animation == "land" and $AnimatedSprite2D.frame >= 4:
		jumpfinished = true
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "jumpstart" and $AnimatedSprite2D.frame >= 4:
			$AnimatedSprite2D.play("jump")
