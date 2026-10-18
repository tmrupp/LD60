extends CSGBox3D

@onready var enemy_prefab = "res://scenes/enemy.tscn"
var spawn_rate = 10.0
@onready var main = $".."

@onready var timer = Timer.new()

func _spawn_enemy ():
	var enemy = load(enemy_prefab).instantiate()
	main.add_child(enemy)
	enemy.position = position

func _ready() -> void:
	add_child.call_deferred(timer)
	timer.wait_time = spawn_rate
	timer.timeout.connect(_spawn_enemy)
	timer.start.call_deferred()
