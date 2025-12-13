extends RigidBody2D

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass 



func _process(_delta: float) -> void:
	if ray_cast_2d.is_colliding():
		freeze = true
		animated_sprite_2d.play("splash")


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
