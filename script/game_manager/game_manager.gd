extends Node

var nbr_platforme = 0
var orientation_platforme = "horizontale"

#camera
var zoom_camera: Vector2 = Vector2(0.75, 0.75)
var CameraFocusOnPlayer = true
var position_camera: Vector2

#quand le joueur est en train de se regen
var player_in_regen = false


#quand le joueuer est en burst
var player_in_burst = true
#savoir quand le joueur peux burst
var if_player_burst = false
#le burst equipe en ce moment
var burst_equip: String = "long_time"

#resaparition au poit de spawn
var respawn_point: Vector2 = Vector2(0 , 0 )

#savoir si le joueur est mort
var player_mort = false

#position du joueur
var position_player: Vector2 = Vector2(0, 0)

#la scene par laquelle le joueur viens de sortir
var scene 


#freeze
func framefreeze(timeScale: float, duration: float):
	Engine.time_scale = timeScale
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = 1.0
