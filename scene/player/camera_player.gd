extends Camera2D

@onready var player_p: player = $"../player"


func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	if zoom == Vector2(0.7, 0.7) and player_p.is_on_floor():
		if Input.is_action_pressed("regarder_haut"):
			global_position = GameManager.position_player + Vector2(0 , -300)
		elif Input.is_action_pressed("regarder_bas"):
			global_position = GameManager.position_player + Vector2(0 , 300)
		else:
			global_position = GameManager.position_player
	else :
		global_position = GameManager.position_player
	zoom = GameManager.zoom_camera
	
