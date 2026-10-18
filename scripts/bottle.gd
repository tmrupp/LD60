extends Node3D

@onready var break_sfx: AudioStreamPlayer = $BreakSFX

func receive_impact():
	break_sfx.play()

func yield_ricochets() -> int:
	return 1
