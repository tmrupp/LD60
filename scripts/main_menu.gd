extends Node3D

@onready var play_button: Button = $CanvasLayer/Control/MarginContainer2/VBoxContainer/Button
var game_scene = preload("res://scenes/fps_test.tscn")

func _ready() -> void:
	play_button.pressed.connect(func(): get_tree().change_scene_to_packed(game_scene))
