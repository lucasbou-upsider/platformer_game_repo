extends Sprite2D

func _process(_delta: float) -> void:

	#platforme marker 
	position = get_global_mouse_position()
	if GameManager.first_upsider == true and GameManager.nbr_platforme != 0:
		visible = true
		if GameManager.orientation_platforme == "horizontale":
			rotation = 0.0
		if GameManager.orientation_platforme == "verticale":
			rotation = 1.57079637050629
	else:
		visible = false


#met la platforme en rouge pour pouvoir montrer qu'on ne peux pas le placer
func change_color():
	modulate = Color(0.922, 0.392, 0.408, 0.263)

#remet le platforme en couleur normal
func reset_color():
	modulate = Color(1.0, 1.0, 1.0, 0.263)
