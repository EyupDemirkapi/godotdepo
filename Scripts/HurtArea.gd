extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and get_parent().HEALTH > 0:
		if not get_parent().BYPASSES_INVIS and (body.sprite.animation == "AttackStart" or body.sprite.animation == "AttackLoop" or body.sprite.animation == "AttackEnd"):
			if get_parent().invitimer <= 0:
				get_parent().HEALTH -= body.STRENGTH
				get_parent().invitimer = get_parent().INVI_DURATION
				get_parent().knockback(body.position.x-get_parent().position.x,10.0/get_parent().MASS)
		else:
			if body.invitimer <= 0:
				body.HEALTH -= get_parent().STRENGTH
				body.knockback(body.position.x-get_parent().position.x,10.0*get_parent().STRENGTH)
				body.invitimer = body.INVI_DURATION
