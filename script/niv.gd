extends Node2D

var isntance_platforme_lumiere = preload("res://scene/platforme_lumiere.tscn")
@export var temps_platforme_respawn = 3
var timer_start = false
@onready var progress_bar: ProgressBar = $player/CanvasLayer/ProgressBar
@onready var platforme_timer: Timer = $platforme_timer

func _ready() -> void:
	pass 


func _process(_delta: float) -> void:
	#placage de platforme
	if GameManager.first_upsider == true and  timer_start == false:
		if Input.is_action_just_pressed("platforme"):
			if GameManager.nbr_platforme != 0:
				inst_platforme(get_global_mouse_position())
				GameManager.nbr_platforme -= 1
		if GameManager.nbr_platforme == 0:
			platforme_timer.start()
			timer_start = true
			progress_bar.visible = true

	#timer reload platforme
	progress_bar.value = platforme_timer.wait_time - platforme_timer.time_left 

#ajouter les platformes
func inst_platforme(pos):
	var instance = isntance_platforme_lumiere.instantiate()
	instance.position = pos
	add_child(instance)


func _on_platforme_timer_timeout() -> void:
	progress_bar.value = 0
	progress_bar.visible = false
	GameManager.nbr_platforme = 3
	timer_start = false
