extends Area2D

@export var scene: PackedScene 
@export var sortie = 0


func _ready() -> void:
	print(scene)
	GameManager.sortie = sortie


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		get_tree().change_scene_to_packed(scene)
