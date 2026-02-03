extends RigidBody2D

var is_desintegration = false
var attaque = false
var possible_attaque = false
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var remove_platforme: Timer = $remove_platforme
@onready var point_light_2d_2: PointLight2D = $PointLight2D2
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var attaquearea: Area2D = $attaquearea
@onready var point_light_2d: PointLight2D = $PointLight2D



func _ready() -> void:
	animated_sprite.play("default")
	freeze = true
	lock_rotation = true
	if GameManager.burst_equip == "long_time" and GameManager.player_in_burst == true:
		print("burst !")
		GameManager.player_in_burst = false
		animated_sprite.self_modulate = Color(0.0, 0.0, 1.0)
		remove_platforme.wait_time =4.5
	else:
		remove_platforme.wait_time = 3.0
	remove_platforme.start()

func _process(_delta: float) -> void:
	if possible_attaque == true:
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
		if Input.is_action_just_pressed("attaque"):
			if attaque == false and is_desintegration == false:
				point_light_2d_2.visible = true
		if Input.is_action_just_released("attaque"):
			if is_desintegration == false:
				animated_sprite.play("attaque")
				point_light_2d_2.visible = false
				attaque = true
				activation_attaque()
	elif attaque == false: 
		animated_sprite.modulate = Color(1.0, 1.0, 1.0, 0.545)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if attaque == true:
		if area.is_in_group("ennemie"):
			area.get_parent().degats()
			set_deferred("freeze", true)
			animated_sprite.play("explosion")
			attaquearea.set_deferred("disabled", true)
			await get_tree().create_timer(0.4).timeout
			queue_free()
		elif area.is_in_group("player"):
			area.get_parent().degats(linear_velocity)
			set_deferred("freeze", true)
			animated_sprite.play("explosion")
			attaquearea.set_deferred("disabled", true)
			await get_tree().create_timer(0.4).timeout
			queue_free()

#supprimer la platforme
func _on_remove_platforme_timeout() -> void:
	queue_free()

#quand la platforme se désintegre 
func desintegration():
	if attaque == false:
		is_desintegration = true
		point_light_2d.enabled = false
		attaquearea.set_deferred("disabled", true)
		animated_sprite.play("fondu")
		await get_tree().create_timer(2).timeout
		is_desintegration = false
		queue_free()

func activation_attaque():
	remove_platforme.paused = true
	await get_tree().create_timer(1).timeout
	remove_platforme.paused = false
	remove_platforme.start()
	collision_shape_2d.disabled = true
	freeze = false


func _on_detectionattaquearea_area_entered(area: Area2D) -> void:
	if area.is_in_group("Detectionattaque"):
		possible_attaque = true


func _on_attaquearea_area_exited(area: Area2D) -> void:
	if area.is_in_group("Detectionattaque"):
		possible_attaque = false

func degats():
	pass
