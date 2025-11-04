extends Node2D

@onready var marker_2d: Marker2D = $Marker2D

var respawn_position: Vector2 

func _ready() -> void:
	respawn_position = marker_2d.global_position

func _on_area_2d_area_entered(_area: Area2D) -> void:
	GameManager.respawn_point = respawn_position
