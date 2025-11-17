extends Node2D

var isntance_platforme_lumiere_verticale = preload("res://scene/platforme_lumiere_vericale.tscn")
var isntance_platforme_lumiere_horizontale = preload("res://scene/platforme_lumiere_horizontale.tscn")
@export var temps_platforme_respawn = 3
var timer_start = false
@onready var progress_bar: ProgressBar = $player/CanvasLayer/ProgressBar
@onready var platforme_timer: Timer = $platforme_timer
@onready var platforme_marker: Sprite2D = $platforme_marker

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	
	#platforme marker 
	platforme_marker.position = get_global_mouse_position()
	if GameManager.first_upsider == true and timer_start == false:
		platforme_marker.visible = true
		if GameManager.orientation_platforme == "horizontale":
			platforme_marker.rotation = 0.0
		if GameManager.orientation_platforme == "verticale":
			platforme_marker.rotation = 1.57079637050629
	else:
		platforme_marker.visible = false
	
	#placage de platforme
	if GameManager.first_upsider == true and timer_start == false:
		if Input.is_action_just_pressed("platforme"):
			if GameManager.nbr_platforme != 0:
				if GameManager.orientation_platforme == "horizontale":
					inst_platforme_horizontale(get_global_mouse_position())
				if GameManager.orientation_platforme == "verticale":
					inst_platforme_verticale(get_global_mouse_position())
				GameManager.nbr_platforme -= 1
		if GameManager.nbr_platforme == 0:
			platforme_timer.start()
			timer_start = true
			progress_bar.visible = true
	
	if Input.is_action_just_pressed("orientation_platforme"):
		if GameManager.orientation_platforme == "horizontale":
			GameManager.orientation_platforme = "verticale"
		elif GameManager.orientation_platforme == "verticale":
			GameManager.orientation_platforme = "horizontale"
	
	#timer reload platforme
	progress_bar.value = platforme_timer.wait_time - platforme_timer.time_left 

#ajouter les platformes
func inst_platforme_horizontale(pos):
	var instance = isntance_platforme_lumiere_horizontale.instantiate()
	instance.position = pos
	add_child(instance)
func inst_platforme_verticale(pos):
	var instance = isntance_platforme_lumiere_verticale.instantiate()
	instance.position = pos
	add_child(instance)

func _on_platforme_timer_timeout() -> void:
	progress_bar.value = 0
	progress_bar.visible = false
	GameManager.nbr_platforme = 3
	timer_start = false
