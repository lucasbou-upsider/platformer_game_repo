extends Camera2D

@onready var player_p: player = $"../player"
var resetzoom: Vector2
var decallage = 15
var negatif_decallage = -20



func _ready() -> void:
	resetzoom = GameManager.zoom_camera



func _process(_delta: float) -> void:
	if GameManager.CameraFocusOnPlayer == true:
		if zoom == resetzoom :
			if player_p.facing_right == true:
				GameManager.position_camera = GameManager.position_player + Vector2(decallage, 0)
				if player_p.is_on_floor() and player_p.velocity == Vector2(0, 0):
					if Input.is_action_pressed("regarder_haut"):
						GameManager.position_camera = GameManager.position_player + Vector2(decallage , -300)
					elif Input.is_action_pressed("regarder_bas"):
						GameManager.position_camera = GameManager.position_player + Vector2(decallage , 300)
			else:
				GameManager.position_camera = GameManager.position_player + Vector2(negatif_decallage, 0)
				if player_p.is_on_floor() and player_p.velocity == Vector2(0, 0):
					if Input.is_action_pressed("regarder_haut"):
						GameManager.position_camera = GameManager.position_player + Vector2(negatif_decallage , -300)
					elif Input.is_action_pressed("regarder_bas"):
						GameManager.position_camera = GameManager.position_player + Vector2(negatif_decallage , 300)

	zoom = GameManager.zoom_camera
	global_position = GameManager.position_camera
