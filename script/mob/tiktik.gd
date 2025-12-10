extends CharacterBody2D

var facing_right 
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var SPEED = -50
var protecte = false
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_cast_2d_2: RayCast2D = $RayCast2D2

func _ready() -> void:
	aleatoire_protect()
	animated_sprite_2d.play("walk")
	animation_player.play("RESET")


func _physics_process(delta: float) -> void:
	#gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	#flip
	if !ray_cast_2d.is_colliding() && is_on_floor()  or ray_cast_2d_2.is_colliding() && is_on_floor():
		flip()

	#vitesse de déplacement
	if protecte == true:
		velocity.x = 0
	else :
		velocity.x = SPEED

	move_and_slide()


func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right or SPEED < 0 :
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1

func aleatoire_protect():
	var random_number = RandomNumberGenerator.new()
	var nbr_random_number= random_number.randi_range(1, 2)
	await get_tree().create_timer(4).timeout
	if nbr_random_number == 1:
		protect()
	if nbr_random_number == 2:
		aleatoire_protect()

#quand le mob se protege
func protect():
	protecte = true
	animation_player.play("flash")
	await get_tree().create_timer(2).timeout
	protecte = false
	aleatoire_protect()

#quand le tiktik prend des degats 
func degats():
	if protecte == false:
		queue_free()
	else :
		GameManager.framefreeze(0.1,0.5)
