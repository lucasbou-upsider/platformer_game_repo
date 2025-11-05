extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GameManager.nbr_platforme = 3
		GameManager.first_upsider = true
		GameManager.respawn_point = global_position
		queue_free()
