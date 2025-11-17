extends RigidBody2D

var attaque = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var remove_platforme: Timer = $remove_platforme


func _ready() -> void:
	freeze = true
	lock_rotation = true
	remove_platforme.start()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attaque"):
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
