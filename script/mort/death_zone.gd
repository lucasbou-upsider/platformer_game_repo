extends Area2D

func _ready() -> void:
	pass



func _process(_delta: float) -> void:
	pass


func _on_area_entered(_area: Area2D) -> void:
	GameManager.player_mort = true
