extends Area2D

var isAttackable = false
@onready var player = $/root/Game/Modulate/Player

func _physics_process(delta: float) -> void:
	if get_parent().HEALTH > 0 and isAttackable:
		if not get_parent().BYPASSES_INVIS and (player.sprite.animation == "AttackStart" or player.sprite.animation == "AttackLoop" or player.sprite.animation == "AttackEnd"):
			if get_parent().invitimer <= 0:
				get_parent().HEALTH -= player.STRENGTH
				get_parent().invitimer = get_parent().INVI_DURATION
				get_parent().knockback(player.position.x-get_parent().position.x,10.0/get_parent().MASS)
		else:
			if player.invitimer <= 0 and get_parent().attacking:
				player.HEALTH -= get_parent().STRENGTH
				player.knockback(player.position.x-get_parent().position.x,10.0*get_parent().STRENGTH)
				player.invitimer = player.INVI_DURATION

func _on_body_entered(body: Node2D) -> void:
	if body == player:
		isAttackable = true

func _on_body_exited(body: Node2D) -> void:
	if body == player:
		isAttackable = false
