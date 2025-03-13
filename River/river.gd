extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hook: Area2D = $Hook
@onready var fish_spawn_zone: Area2D = $FishSpawnZone

const REELING_SPEED = 100
var normalised_vector
var hooked_fish
var reeling = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hooked_fish != null:
		if reeling:
			normalised_vector = (player.position-hooked_fish.position).normalized()
			hooked_fish.position += normalised_vector * REELING_SPEED * delta
		else:
			hooked_fish.position.y -= 50 * delta
		if hooked_fish.position.y < get_viewport_rect().position.y - 50:
			reset_hook()
			stop_reeling_and_reset_fish()
	
	
func _on_player_throw_hook(throw_distance: Variant) -> void:
	hook.position.x = player.position.x
	hook.position.y = player.position.y - throw_distance
	hook.visible = true

func _on_player_retract_hook() -> void:
	reset_hook()

func _on_fish_spawn_zone_fish_hooked(fish: Variant) -> void:
	reset_hook()
	player.begin_reeling()
	hooked_fish = fish
	hook.visible = false

func _on_player_reeling() -> void:
	reeling = true

func _on_player_relaxing() -> void:
	reeling = false

func _on_fish_spawn_zone_fish_caught(fish: Variant) -> void:
	stop_reeling_and_reset_fish()

func _on_player_max_tension() -> void:
	stop_reeling_and_reset_fish()

func _on_fish_spawn_zone_fish_obstacle_hit(fish: Variant) -> void:
	stop_reeling_and_reset_fish()

func reset_hook():
	hook.position.x = player.position.x
	hook.position.y = player.position.y
	hook.visible = false

func stop_reeling_and_reset_fish():
	reeling = false
	player.stop_reeling()
	hooked_fish.queue_free()
	fish_spawn_zone.start_fish_spawn_timer()
