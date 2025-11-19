extends RigidBody2D

var attaque = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var remove_platforme: Timer = $remove_platforme
@onready var point_light_2d_2: PointLight2D = $PointLight2D2


func _ready() -> void:
	freeze = true
	lock_rotation = true
	remove_platforme.start()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attaque"):
		if attaque == false:
			point_light_2d_2.visible = true
	if Input.is_action_just_released("attaque"):
		point_light_2d_2.visible = false
		remove_platforme.start()
		attaque = true
	
	if attaque == true:
		collision_shape_2d.disabled = true
		freeze = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if attaque == true:
		if area.is_in_group("player"):
			area.get_parent().degats()
			queue_free()
		if area.is_in_group("ennemie"):
			area.get_parent().degats()
			queue_free()

func _on_remove_platforme_timeout() -> void:
	queue_free()

#quand la platforme se désintegre 
func desintegration():
	if attaque == false:
		queue_free()
