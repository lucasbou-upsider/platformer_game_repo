extends Node2D

var vole = false
var player_detected = false
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var area_oiseau: Area2D = $area_oiseau
@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

func _ready() -> void:
	sprite_2d.play("idle")


func _process(_delta: float) -> void:
	if vole == true:
		global_position += Vector2(10.0 , -5.0)
		await get_tree().create_timer(5).timeout
		queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		sprite_2d.play("preparation_vole")


func _on_sprite_2d_animation_finished() -> void:
	sprite_2d.play("vole")
	vole = true


func _on_area_oiseau_area_entered(area: Area2D) -> void:
	if area.is_in_group("platforme"):
		cpu_particles_2d.emitting = true
		visible = false
		await get_tree().create_timer(2).timeout
		queue_free()
