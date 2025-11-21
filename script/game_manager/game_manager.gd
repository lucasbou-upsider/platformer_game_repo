extends Node

var nbr_platforme = 0
var orientation_platforme = "horizontale"

#zoom de la camera
var zoom_camera: Vector2 = Vector2(0.7, 0.7)


#quand le joueur est en train de se regen
var player_in_regen = false

#debloquage du premiere upside
var first_upsider = false

#resaparition au poit de spawn
var respawn_point: Vector2 = Vector2(0 , 0 )

#savoir si le joueur est mort
var player_mort = false
