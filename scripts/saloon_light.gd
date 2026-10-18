extends StaticBody3D

@onready var break_sfx: AudioStreamPlayer = $BreakSFX
@onready var light_on: MeshInstance3D = $LightOn
@onready var light_off: MeshInstance3D = $LightOff
@onready var spot_light_3d: SpotLight3D = $SpotLight3D

func receive_impact():
	break_sfx.play()
	light_on.hide()
	light_off.show()
	spot_light_3d.hide()

func yield_ricochets() -> int:
	return 1
