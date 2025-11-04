extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	GameManager.nbr_platforme = 3
	GameManager.first_upsider = true
	GameManager.respawn_point = global_position
	queue_free()
