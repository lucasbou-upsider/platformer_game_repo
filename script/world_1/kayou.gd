extends RigidBody2D

var flotte = true
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite_2d.play("charge")
	await get_tree().create_timer(2).timeout
	flotte = false



func _process(_delta: float) -> void:
	if flotte == true:
		freeze = true
		global_position = GameManager.position_player
		position.y -= 300
	else :
		animated_sprite_2d.play("RESET")
		freeze = false


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("player") or area.is_in_group("platforme"):
		queue_free()

func degats():
	pass


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("tremble")
