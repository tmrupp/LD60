extends Node3D

@onready var break_sfx: AudioStreamPlayer = $BreakSFX

func receive_impact(impact_point_world : Vector3):
	break_sfx.play()

func yield_ricochets() -> int:
	return 1
