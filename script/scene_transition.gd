extends Area2D

@export var scene: PackedScene 
@export var current_scene: PackedScene
@export var distance_sortie: int
@onready var player_pos: player = $"../player"

func _ready() -> void:
	scene = scene
	if scene == GameManager.sortie:
		player_pos.global_position = global_position + Vector2(distance_sortie , 0)
	print(scene)
	


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GameManager.sortie = current_scene
		get_tree().change_scene_to_packed(scene)
