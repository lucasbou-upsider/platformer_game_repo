extends CharacterBody2D

class_name player

#platforme
@onready var ui_platforme_animation: AnimationPlayer = $CanvasLayer/ui_platforme_animation
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var progresse_bar_timer: Timer = $"CanvasLayer/progresse bar timer"

#vitesse
@export var speed = 250.0
var courir = false
@onready var particule_course: CPUParticles2D = $particule_course

#saut
const JUMP_VELOCITY = -500.0
@onready var jump_timer: Timer = $jump_timer
var can_jump = false
var coyote_time = 0.3
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var aceleration = 0.1

func _physics_process(delta: float) -> void:
	
	ui_platforme()
	mort()
	platforme_reload()
	
	# gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	#coyote time
	if is_on_floor() and can_jump == false:
		can_jump = true
	elif can_jump == true and jump_timer.is_stopped():
		jump_timer.start(coyote_time)

	#saut dosable
	if Input.is_action_just_released("saut") and velocity.y < 0:
		velocity.y = JUMP_VELOCITY / 4
	if Input.is_action_just_pressed("saut") and can_jump == true:
		can_jump = false
		velocity.y = JUMP_VELOCITY

	#direction
	var direction := Input.get_axis("gauche", "droite")
	if direction:
		velocity.x = move_toward(velocity.x , direction * speed, aceleration * speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	#course
	if Input.is_action_just_pressed("courire"):
		if courir == false:
			particule_course.emitting = true
			speed = 350.0
			courir = true
		else:
			speed = 250.0
			courir = false


	move_and_slide()


func _on_jump_timer_timeout() -> void:
	can_jump = false

func mort():
	if GameManager.player_mort == true:
		global_position = GameManager.respawn_point
		GameManager.player_mort = false
		print("mort")
		#aaaaa


func ui_platforme():
	ui_platforme_animation.play(str(GameManager.nbr_platforme))

func platforme_reload():
	if GameManager.nbr_platforme == 0:
		progresse_bar_timer.start()
		progress_bar.value = progresse_bar_timer.wait_time
