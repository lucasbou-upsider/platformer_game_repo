extends CharacterBody2D

var facing_right 
@onready var ray_cast_2d: RayCast2D = $RayCast2D
var SPEED = -50


func _physics_process(delta: float) -> void:

	if not is_on_floor():
		velocity += get_gravity() * delta

	if !ray_cast_2d.is_colliding() && is_on_floor():
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

func protect():
	pass
	
func degats():
	queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("platforme"):
		area.get_parent().desintegration()
