extends CharacterBody2D

var SPEED: int = 0
var facing_right = false
var chasser_player = false
@onready var move_timer: Timer = $move_timer
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D



func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip()
	
	velocity.x = SPEED
	
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right or SPEED < 0 :
		SPEED = abs(SPEED)
	else:
		SPEED = abs(SPEED) * -1
		

var gauche = true

func _on_move_timeout() -> void:
	var aletoire_number =  RandomNumberGenerator.new()
	var nbr = aletoire_number.randi_range(0 , 5)
	if !chasser_player:
		if nbr >= 2:
			if gauche == true:
				animated_sprite_2d.play("walk")
				SPEED = 20
				flip()
				await  get_tree().create_timer(5).timeout
				SPEED = 0
				animated_sprite_2d.play("idle")
				gauche = false
			if gauche == false:
				animated_sprite_2d.play("walk")
				SPEED = 20
				flip()
				await  get_tree().create_timer(5).timeout
				animated_sprite_2d.play("idle")
				SPEED = 0
				gauche = true
		if nbr <= 1:
			SPEED = 0
			animated_sprite_2d.play("idle")


func _on_attaque_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		chasser_player = true
		SPEED = 0
		animated_sprite_2d.play("attaque")


func _on_animated_sprite_2d_animation_finished() -> void:
	chasser_player = false


func _on_attaque_2_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		flip()
		chasser_player = true
		SPEED = 0
		animated_sprite_2d.play("attaque")
