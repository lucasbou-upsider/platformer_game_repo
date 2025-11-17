extends CharacterBody2D

class_name player

#vie
var pv = 3


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
const fall_gravity = 1600
var nbr_de_saut = 0

#wall jump
@export_category("wall jump variable")
@export var wall_slide = 150
@onready var right_ray: RayCast2D = $raycast/right_ray
@export var wall_x_force = 200
@export var wall_y_force = -750
var is_wall_jumping = false

#dash
@export_category("dash variable")
@export var dash_speed = 600.0
@export var facing_right = true
@export var dash_gravity = 0
var dash_key_pressed = 0
var is_dashing = false
var nbr_dash = 1

func _physics_process(delta: float) -> void:
	
	wall_logique()
	ui_platforme()
	mort()
	platforme_reload()
	flip()
	
	# gravité
	if not is_on_floor() and is_dashing == false:
		velocity.y +=  get_good_gravity() * delta
	elif is_dashing == true:
		velocity.y = dash_gravity

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
	if is_wall_jumping == false and is_dashing == false:
		var direction := Input.get_axis("gauche", "droite")
		if direction:
			velocity.x = move_toward(velocity.x , direction * speed, aceleration * speed)
		else:
			velocity.x = move_toward(velocity.x, 0, speed * deceleration)

	#dash
	if Input.is_action_just_pressed("courire") and dash_key_pressed ==0 and nbr_dash == 1:
		dash_key_pressed = 1
		nbr_dash -= 1
		dash()
	if is_on_floor() or is_on_wall():
		nbr_dash = 1

	move_and_slide()

#wall jump
func wall_logique():
	if is_on_wall():
		velocity.y = wall_slide
		if Input.is_action_just_pressed("saut"):
			if right_ray.is_colliding():
				velocity = Vector2(-wall_x_force, wall_y_force)
				wall_jumping()
func wall_jumping():
	is_wall_jumping = true
	await get_tree().create_timer(0.12).timeout
	is_wall_jumping = false

#dash
func dash():
	if dash_key_pressed == 1:
		is_dashing = true
	else :
		is_dashing = false
		
	if facing_right == true:
		velocity.x = dash_speed
		dash_started()
	if facing_right == false:
		velocity.x = -dash_speed
		dash_started()
func dash_started():
	if is_dashing == true:
		dash_key_pressed = 1
		await get_tree().create_timer(0.2).timeout
		is_dashing = false
		await get_tree().create_timer(0.2).timeout
		dash_key_pressed = 0
	else:
		return


#flip players
func flip():
	if velocity.x > 0.0:
		facing_right = true
		scale.x = scale.y * 1
		wall_x_force = 250.0
	if velocity.x < 0.0:
		facing_right = false
		scale.x = scale.y * -1
		wall_x_force = -250.0


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
	if GameManager.player_mort == true or pv == 0:
		global_position = GameManager.respawn_point
		GameManager.player_mort = false
		pv = 3
		print("mort")
func degats():
	pv -=1




#comptage du nbr de platforme ui
func ui_platforme():
	ui_platforme_animation.play(str(GameManager.nbr_platforme))

#permet de recevoi les platforme a la fin du timer
func platforme_reload():
	if GameManager.nbr_platforme == 0:
		progresse_bar_timer.start()
		progress_bar.value = progresse_bar_timer.wait_time
