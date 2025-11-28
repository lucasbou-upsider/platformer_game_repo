extends Area2D

#arret des platformes dans la zone noir
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("platforme") :
		area.get_parent().desintegration()
	if area.is_in_group("platforme_marker"):
		area.get_parent().change_color()


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("platforme_marker"):
		area.get_parent().reset_color()
