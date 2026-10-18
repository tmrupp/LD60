extends TextureRect

var time_remaining : float = -1
var starting_time_amount : float = 0
var callback : Variant = null

func _process(delta: float) -> void:
	if time_remaining > 0:
		time_remaining -= delta
		material.set_shader_parameter("limit", time_remaining / starting_time_amount)
		if time_remaining <= 0:
			if callback != null:
				callback.call()
			hide()

func start_timer(seconds : float, _callback : Callable):
	show()
	starting_time_amount = seconds
	time_remaining = seconds
	callback = _callback

func clear_timer():
	hide()
	callback = null
