extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fish_spawn_timer: Timer = $FishSpawnTimer
const FISH = preload("res://Fish/fish.tscn")

signal fish_caught(fish)
signal fish_hooked(fish)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fish_spawn_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_fish_spawn_timer_timeout() -> void:
	var new_fish = FISH.instantiate()
	new_fish.hooked.connect(on_fish_hooked)
	new_fish.caught.connect(on_fish_caught)
	#new_fish.lost.connect(on_fish_lost)
	new_fish.position = random_spawn_location()
	new_fish.add_to_group("fish")
	get_tree().root.add_child(new_fish)


func random_spawn_location() -> Vector2:
	var spawn_x_range = collision_shape_2d.shape.get_rect().size.x - 50
	var spawn_y_range = collision_shape_2d.shape.get_rect().size.y - 50
	var spawn_location = Vector2(randi_range(0, spawn_x_range), randi_range(0, spawn_y_range))
	return spawn_location

func on_fish_hooked(fish):
	fish_hooked.emit(fish)


func on_fish_caught(fish):
	fish_caught.emit(fish)
	

func on_fish_lost():
	pass


func start_fish_spawn_timer():
	fish_spawn_timer.wait_time = 3
	fish_spawn_timer.start()
