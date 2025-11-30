extends Area2D

@export var scene: String
@export var curent_scene: String
@export var direction : int
@onready var player_pos: player = $"../player"


func _ready() -> void:
	if GameManager.scene == curent_scene:
		player_pos.global_position = global_position + Vector2(direction, 0)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		GameManager.scene = scene
		get_tree().change_scene_to_file.call_deferred(scene)
