extends Control


func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GameManager.CameraFocusOnPlayer = false
		GameManager.position_camera = Vector2(11385, 2080)


func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		GameManager.CameraFocusOnPlayer = true
