extends CharacterBody2D

class_name player

#vie
var pv = 3
var invulnerability_time = 3
var hit = false
@onready var area: Area2D = $area #area de la detection de la collision entre le joueur et les ennemies
@onready var ui_life_animation: AnimationPlayer = $CanvasLayer/BoxContainer2/ui_life_animation #montre la vie du joueur
@onready var collision_area: CollisionShape2D = $area/Collision_area #collision de l'area entre le joueur et les ennemie

#regen
@onready var regen_timer: Timer = $regen_timer #temps de la régenération du joueur

#platforme
@onready var ui_platforme_animation: AnimationPlayer = $CanvasLayer/BoxContainer/ui_platforme_animation #ui qui montre le nombre de platforme restant au joueur
@onready var progress_bar: ProgressBar = $CanvasLayer/ProgressBar #barre de rechargement de platforme
@onready var progresse_bar_timer: Timer = $"CanvasLayer/progresse bar timer"# le temps que prends les platfromes à se recharger

#vitesse
@export var speed = 300.0
@onready var particule_course: CPUParticles2D = $particule_course #particule quand le joueur court

#saut
const JUMP_VELOCITY = -600.0
@onready var jump_timer: Timer = $jump_timer2/jump_timer #savoir si le joueur peux sauter pour le coyote time
var can_jump = false #savoir si le joueur peux sauter
var coyote_time = 0.3 
@export_range(0, 1) var deceleration = 0.1 # decelration du joueur quand il bouge 
@export_range(0, 1) var aceleration = 0.1 # aceleration du joueur quand il bouge 
const gravity = 1100 #gravité du joueur
const fall_gravity = 1600 #gravité du joueur augmenté quand il tombe

#wall jump
@export_category("wall jump variable") 
@export var wall_slide = 150 #force à laquelle le joueur glisse sur le mur 
@onready var right_ray: RayCast2D = $raycast/right_ray #raycast pour detecter si le joueur est contre le mur
@onready var right_ray_2: RayCast2D = $raycast/right_ray2 #raycast pour detecter si le joueur est contre le mur
@export var wall_x_force = 200 #velocité du joueur quand il est sur le mur
@export var wall_y_force = -750 #velocité du joueur quand il est sur le mur
var is_wall_jumping = false #savoir si le joueur saute d'un mur

#dash
@export_category("dash variable")
@export var dash_speed = 600.0 #vitesse du dash
@export var facing_right = true #savoir si le joueur regarde à gauche
@export var dash_gravity = 0 #gravité reset pendant le dash
var dash_key_pressed = 0 #savoir si la touche de dash à été préssé
var is_dashing = false #savoir si le joueur dash
var nbr_dash = 1 #savoir le nbr de dahs restant au joueur

func _physics_process(delta: float) -> void:

	wall_logique()
	ui_platforme()
	mort()
	platforme_reload()
	flip()
	life()
	
	
	# gravité
	if not is_on_floor() and is_dashing == false and hit == false:
		velocity.y +=  get_good_gravity() * delta
	elif is_dashing == true:
		velocity.y = dash_gravity
	
	#limite de la vitesse quand le joueur tombe
	if velocity.y >= 1600:
		velocity.y = 1600
	
	
	
	
	#coyote time
	if is_on_floor() and can_jump == false and is_dashing == false:
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
	if is_wall_jumping == false and is_dashing == false and GameManager.player_in_regen == false:
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

	#regen
	if Input.is_action_just_pressed("regen"):
		if GameManager.nbr_platforme == 3 and is_on_floor():
			regen()
	#zomme pendant le regen
	if GameManager.player_in_regen == true:
		GameManager.zoom_camera += Vector2(0.00015, 0.00015)

	move_and_slide()

#affichage de la vie du joueur
func life():
	ui_life_animation.play(str(pv))

#regeneration des pvs du joueur
func regen():
	GameManager.player_in_regen = true 
	velocity.x = 0
	GameManager.nbr_platforme = 0
	regen_timer.start()
func _on_regen_timer_timeout() -> void:
	pv = 3
	GameManager.player_in_regen = false
	GameManager.zoom_camera = Vector2(0.7, 0.7)

#wall jump
func wall_logique():
	if is_on_wall():
		velocity.y = wall_slide
		if Input.is_action_just_pressed("saut"):
			if right_ray.is_colliding() or right_ray_2.is_colliding():
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

#quand le joueur perd des pv
func degats():
	#si le joueur prends un degat pendant la regeneration
	if GameManager.player_in_regen == true:
		regen_timer.stop()
		GameManager.player_in_regen = false
		GameManager.zoom_camera = Vector2(0.7, 0.7)
	hit = true
	position.y -= 20
	if velocity.x > 0:
		position.x -= 20
	elif velocity.x < 0:
		position.x += 20
	GameManager.framefreeze(0.1, 0.5) #arret du temps pendnat le regen
	collision_area.set_deferred("disabled", true) 
	pv -=1
	hit = false
	await get_tree().create_timer(invulnerability_time).timeout #temps de l'invulnerabilité du joueur
	collision_area.set_deferred("disabled", false) 

#comptage du nbr de platforme ui
func ui_platforme():
	ui_platforme_animation.play(str(GameManager.nbr_platforme))

#permet de recevoi les platforme a la fin du timer
func platforme_reload():
	if GameManager.nbr_platforme == 0:
		progresse_bar_timer.start()
		progress_bar.value = progresse_bar_timer.wait_time

#degats
func _on_area_2d_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("ennemie"):
		degats()
