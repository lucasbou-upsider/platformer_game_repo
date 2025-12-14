extends CharacterBody2D

var kayou = preload("res://scene/world_1/kayou.tscn")
var can_invocate = true
var is_in_area = false
var in_invocate = false
var vulnebilarity_moment = 3
@onready var reload: Timer = $reload
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	#gere les déplacement
	move()


func _physics_process(delta: float) -> void:
	
	animation()
	
	#gravité
	if not is_on_floor():
		velocity += get_gravity() * delta

	#invoque le rocher si le joueur est dans l'area et si le timer est fini
	invocation_kayou()

	if in_invocate == true:
		velocity.x = 0

	move_and_slide()
	
func move():
	velocity.x = 10
	animated_sprite_2d.flip_h = false
	await get_tree().create_timer(6).timeout
	animated_sprite_2d.flip_h = true
	velocity.x = -10
	await get_tree().create_timer(6).timeout
	move()

#gere l'invocation du kayou
func invocation_kayou():
	if is_in_area == true and can_invocate == true:
		in_invocate = true
		var kayou_instance = kayou.instantiate()
		get_parent().add_child(kayou_instance)
		can_invocate = false
		reload.start()
		await get_tree().create_timer(vulnebilarity_moment).timeout
		in_invocate = false
#invocation detection area
func _on_detecteur_invoc_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_in_area = true
		print("area entered")
func _on_detecteur_invoc_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		is_in_area = false
		print("area sorted")
#reload de l'invoc 
func _on_reload_timeout() -> void:
	can_invocate = true

#degats
func degats():
	if in_invocate == true:
		queue_free()
	else :
		GameManager.framefreeze(0.1,0.5)

func animation():
	if in_invocate == true:
		animated_sprite_2d.play("attaque")
	elif  velocity.x != 0:
		animated_sprite_2d.play("walk")
	elif  velocity.x == 0:
		animated_sprite_2d.play("idle")
	
