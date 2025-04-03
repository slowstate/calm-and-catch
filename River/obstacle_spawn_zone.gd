extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var obstacle_spawn_timer: Timer = $ObstacleSpawnTimer
const LOG = preload("res://Log/log.tscn")
const COLLECTIBLE = preload("res://Collectibles/collectible.tscn")

signal collectible_hooked(collectible)
signal collectible_caught(collectible)
signal collectible_obstacle_hit(collectible)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	obstacle_spawn_timer.wait_time = 3
	obstacle_spawn_timer.start()


func _on_obstacle_spawn_timer_timeout() -> void:
	var obstacle_type = randi_range(1,100)
	if obstacle_type >100:
		var new_obstacle = LOG.instantiate()
		new_obstacle.position = random_spawn_location()
		get_tree().root.add_child(new_obstacle)
		obstacle_spawn_timer.wait_time = randi_range(5, 10)
		obstacle_spawn_timer.start()
	else:
		var new_collectible = COLLECTIBLE.instantiate()
		new_collectible.hooked.connect(on_collectible_hooked)
		new_collectible.caught.connect(on_collectible_caught)
		new_collectible.obstacle_hit.connect(on_collectible_obstacle_hit)
		new_collectible.position = random_spawn_location()
		get_tree().root.add_child(new_collectible)
		obstacle_spawn_timer.wait_time = randi_range(5, 10)
		obstacle_spawn_timer.start()
		

func random_spawn_location() -> Vector2:
	var spawn_x_min = position.x - collision_shape_2d.shape.get_rect().size.x/2
	var spawn_x_max = position.x + collision_shape_2d.shape.get_rect().size.x/2
	var spawn_y_min = position.y - collision_shape_2d.shape.get_rect().size.y/2
	var spawn_y_max = position.y + collision_shape_2d.shape.get_rect().size.y/2
	var spawn_location = Vector2(randi_range(spawn_x_min, spawn_x_max), randi_range(spawn_y_min, spawn_y_max))
	return spawn_location
	
func on_collectible_hooked(collectible):
	collectible_hooked.emit(collectible)


func on_collectible_caught(collectible):
	collectible_caught.emit(collectible)
	

func on_collectible_obstacle_hit(collectible):
	collectible_obstacle_hit.emit(collectible)
