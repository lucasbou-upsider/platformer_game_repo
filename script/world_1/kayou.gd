extends RigidBody2D

var flotte = true

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	flotte = false



func _process(_delta: float) -> void:
	if flotte == true:
		freeze = true
		global_position = GameManager.position_player
		position.y -= 300
	else:
		freeze = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("platforme"):
		queue_free()

func degats():
	pass
