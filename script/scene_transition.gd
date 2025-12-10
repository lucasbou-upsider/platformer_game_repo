extends Area2D

@export var scene: String
@export var curent_scene: String
@export var direction : int
@onready var player_pos: player = $"../player"
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer


func _ready() -> void:
	animation_player.play("part")
	#if ResourceLoader.load_threaded_get_status(scene) == ResourceLoader.THREAD_LOAD_LOADED:
		#set_process(false)
		#var new_scene: PackedScene = ResourceLoader.load_threaded_get(scene)
		#get_tree().change_scene_to_file.call_deferred(new_scene)
	if GameManager.scene == curent_scene:
		player_pos.global_position = global_position + Vector2(direction, 0)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		animation_player.play("viens")
		GameManager.scene = scene
		get_tree().change_scene_to_file.call_deferred(scene)
