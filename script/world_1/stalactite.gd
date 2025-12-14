extends Node2D

@onready var marker_2d: Marker2D = $Marker2D
var instance_goutte = preload("res://scene/world_1/goutte_de_vide.tscn")
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func invoc_void():
	var goutte_vide = instance_goutte.instantiate()
	goutte_vide.position = marker_2d.position
	add_child(goutte_vide)


func _on_timer_timeout() -> void:
	animated_sprite_2d.play("goutte")


func _on_animated_sprite_2d_animation_finished() -> void:
	timer.start()
	invoc_void()

func degats():
	pass
