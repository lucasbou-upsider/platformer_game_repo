extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_area_entered(_area: Area2D) -> void:
	print("dezzooooomme")
	animation_player.play("dezoom")
	await get_tree().create_timer(9.0).timeout
	queue_free()
