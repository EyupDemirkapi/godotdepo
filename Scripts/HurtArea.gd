extends Area2D

@onready var player = $root/Game/Player

func body_entered(body):
	if body == player:
		if body.sprite.animation == "AttackStart" or body.sprite.animation == "AttackLoop" or body.sprite.animation == "AttackEnd":
			if get_parent().invitimer <= 0:
				get_parent().HEALTH -= body.STRENGTH
				get_parent().invitimer = get_parent().INVI_DURATION
				get_parent().knockback(body.position.x-get_parent().position.x,10)
		else:
			if body.invitimer <= 0:
				body.HEALTH -= get_parent().STRENGTH
				body.invitimer = body.INVI_DURATION
