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
const JUMP_VELOCITY = -600.0
@onready var jump_timer: Timer = $jump_timer
var can_jump = false
var coyote_time = 0.3
@export_range(0, 1) var deceleration = 0.1
@export_range(0, 1) var aceleration = 0.1
@onready var jump_buffer_timer: Timer = $jump_buffer_timer
var saut = 0
const gravity = 1000
const fall_gravity = 1400
var nbr_de_saut = 0

#wall jump
@export_category("wall jump variable")
@export var wall_slide = 150
@onready var right_ray: RayCast2D = $raycast/right_ray
@export var wall_x_force = 200
@export var wall_y_force = -750
var is_wall_jumping = false

func _physics_process(delta: float) -> void:
	
	wall_logique()
	ui_platforme()
	mort()
	platforme_reload()
	flip()
	
	# gravité
	if not is_on_floor():
		velocity.y +=  get_good_gravity() * delta

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
	#if Input.is_action_just_released("saut") and velocity.y < 0:
		#jump_buffer_timer.start()
		#saut = 0
	#if Input.is_action_just_pressed("saut") and can_jump == true:
		#can_jump = false
		#jump_buffer_timer.start()
		#saut = 1
	#if is_on_floor() and !jump_buffer_timer.is_stopped():
		#if saut == 0:
			#print("petit_saut")
			#velocity.y = JUMP_VELOCITY / 4
		#if saut == 1:
			#print("grand_saut")
			#velocity.y = JUMP_VELOCITY
		

	#direction
	if is_wall_jumping == false:
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

#wall jump
func wall_logique():
	if is_on_wall():
		velocity.y = wall_slide
		if Input.is_action_just_pressed("saut"):
			#if left_ray.is_colliding():
				#velocity = Vector2(wall_x_force, wall_y_force)
				#wall_jumping()
			if right_ray.is_colliding():
				velocity = Vector2(-wall_x_force, wall_y_force)
				wall_jumping()
func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false


#flip players
func flip():
	if velocity.x > 0.0:
		scale.x = scale.y * 1
		wall_x_force = 300.0
	if velocity.x < 0.0:
		scale.x = scale.y * -1
		wall_x_force = -300.0


#gravity saut
func get_good_gravity():
	if velocity.y < 0:
		return gravity
	return fall_gravity

#coyot time
func _on_jump_timer_timeout() -> void:
	can_jump = false

#mort
func mort():
	if GameManager.player_mort == true:
		global_position = GameManager.respawn_point
		GameManager.player_mort = false
		print("mort")
		#aaaaa

#comptage du nbr de platforme ui
func ui_platforme():
	ui_platforme_animation.play(str(GameManager.nbr_platforme))

#permet de recevoi les platforme a la fin du timer
func platforme_reload():
	if GameManager.nbr_platforme == 0:
		progresse_bar_timer.start()
		progress_bar.value = progresse_bar_timer.wait_time
