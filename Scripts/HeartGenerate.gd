extends Node

@onready var maxhealth = $/root/Game/Modulate/Player/Stats.MAX_HEALTH
var startPos = Vector2(-174,-90)

func _ready() -> void:
	initialGenerate()

func initialGenerate() -> void:
	for i in range(maxhealth-1,-1,-1):
		var heart = load("res://Scenes/UIHeart.tscn").instantiate()
		heart.position = startPos + Vector2(i*16,0)
		heart.play("Full")
		get_parent().add_child.call_deferred(heart)

func generateHearts(health:int) -> void:
	if health < 0:
		health = 0
	for i in get_parent().get_children():
		if i != self:
			get_parent().remove_child(i)
	for i in range(maxhealth-1,-1,-1):
		var heart = load("res://Scenes/UIHeart.tscn").instantiate()
		heart.position = startPos + Vector2(i*16,0)
		if i > health-1:
			heart.play("Empty")
		else:
			heart.play("Full")
		get_parent().add_child(heart)
