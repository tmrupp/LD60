extends Node3D

@onready var victory_text: Control = $CanvasLayer/VictoryText
@onready var label_2: Label = $CanvasLayer/VictoryText/VBoxContainer/Label2

var outlaw_count : int
var times_shot : int = 0
var done_winning = false

func _process(_delta: float) -> void:
	if outlaw_count <= 0 and not done_winning:
		you_win()
		done_winning = true

func you_win():
	victory_text.show()
	if times_shot == 0:
		label_2.text = "And were completely unscathed!"
	if times_shot == 1:
		label_2.text = "And only got hit once!"
	else:
		label_2.text = "And only got hit " + str(times_shot) + " times!"
