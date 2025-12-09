extends Camera2D

@onready var player_p: player = $"../player"
var resetzoom: Vector2

func _ready() -> void:
	resetzoom = GameManager.zoom_camera



func _process(_delta: float) -> void:
	if GameManager.CameraFocusOnPlayer == true:
		if zoom == resetzoom and player_p.is_on_floor():
			if Input.is_action_pressed("regarder_haut"):
				GameManager.position_camera = GameManager.position_player + Vector2(0 , -300)
			elif Input.is_action_pressed("regarder_bas"):
				GameManager.position_camera = GameManager.position_player + Vector2(0 , 300)
			else:
				GameManager.position_camera = GameManager.position_player
		else :
			GameManager.position_camera = GameManager.position_player

	zoom = GameManager.zoom_camera
	global_position = GameManager.position_camera
