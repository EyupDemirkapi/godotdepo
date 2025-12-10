# TreeEnemy.gd
extends Node2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var aggro_area: Area2D = $AggroArea
@onready var hurt_area: Area2D = $HurtArea
@onready var shadow: Sprite2D = $ShadowSprite
@onready var stats = $Stats
@onready var camera = get_node_or_null("/root/Game/Camera")

@export var attack_interval: float = 0.8
@export var attack_damage: int = 15
@export var play_damage_on_attack: bool = true
@export var auto_free_after_death: bool = true

var is_attacking: bool = false
var attack_timer: float = 0.0
var is_dead: bool = false

func _ready() -> void:
	aggro_area.body_entered.connect(_on_aggro_enter)
	aggro_area.body_exited.connect(_on_aggro_exit)

	if is_instance_valid(stats):
		if stats.has_signal("health_changed"):
			stats.connect("health_changed", Callable(self, "_on_health_changed"))
		if stats.has_signal("died"):
			stats.connect("died", Callable(self, "_on_died"))

	anim.play("idle")


func _physics_process(delta: float) -> void:
	if is_dead:
		return

	_update_shadow()

	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			_perform_attack()


func _on_aggro_enter(body: Node) -> void:
	if is_dead:
		return
	if _is_player(body):
		is_attacking = true
		attack_timer = attack_interval
		anim.play("attack")


func _on_aggro_exit(body: Node) -> void:
	if is_dead:
		return
	if _is_player(body):
		is_attacking = false
		anim.play("idle")


func _perform_attack() -> void:
	if is_dead:
		return

	anim.play("attack")
	attack_timer = attack_interval

	if play_damage_on_attack:
		var bodies = hurt_area.get_overlapping_bodies()
		for b in bodies:
			if _is_player(b):

				if b.has_method("take_damage"):
					b.take_damage(attack_damage)
				else:
					if b.has_variable("HEALTH"):
						b.HEALTH = max(b.HEALTH - attack_damage, 0)
					elif typeof(b.get("HEALTH")) != TYPE_NIL:
						b.set("HEALTH", max(b.get("HEALTH") - attack_damage, 0))

				b.invitimer = b.INVI_DURATION

				if b.has_method("knockback"):
					b.knockback(global_position.x - b.global_position.x, 10)


func _on_health_changed(new_hp: int) -> void:
	if is_dead:
		return
	anim.play("hurt")


func _on_died() -> void:
	if is_dead:
		return

	is_dead = true
	aggro_area.monitoring = false
	hurt_area.monitoring = false
	anim.play("death")

	if auto_free_after_death:
		await anim.animation_finished
		queue_free()


func _is_player(node: Node) -> bool:
	if node == null:
		return false
	if node.name == "Player":
		return true
	if node.is_in_group("Player"):
		return true
	return false


func _update_shadow() -> void:
	if camera and camera.has_method("get_sky_color"):
		var c = camera.get_sky_color()
		shadow.modulate = Color(c.r * 0.4, c.g * 0.4, c.b * 0.4, 1)
