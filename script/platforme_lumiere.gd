extends RigidBody2D

var attaque = false


func _ready() -> void:
	freeze = true
	lock_rotation = true
	await get_tree().create_timer(2).timeout
	queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("attaque"):
		attaque = true
	
	if attaque == true:
		freeze = false
