extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hook: Area2D = $Hook
@onready var fish_spawn_zone: Area2D = $FishSpawnZone
@onready var hook_hit_water_1: AudioStreamPlayer2D = $HookHitWater1
@onready var hook_hit_water_2: AudioStreamPlayer2D = $HookHitWater2
@onready var fish_hooked_1: AudioStreamPlayer2D = $FishHooked1
@onready var fish_hooked_2: AudioStreamPlayer2D = $FishHooked2
@onready var fish_escape_1: AudioStreamPlayer2D = $FishEscape1
@onready var fish_escape_2: AudioStreamPlayer2D = $FishEscape2
@onready var fish_caught_1: AudioStreamPlayer2D = $FishCaught1
@onready var fish_caught_2: AudioStreamPlayer2D = $FishCaught2
@onready var river_1: AudioStreamPlayer2D = $River1
@onready var river_2: AudioStreamPlayer2D = $River2


const REELING_SPEED = 100
var normalised_vector
var hooked_fish
var reeling = false
var sound_picker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_river_sounds()

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
	sound_picker = randf_range(0,2)
	if sound_picker <= 1:
		hook_hit_water_1.volume_db = randf_range(-5,0)
		hook_hit_water_1.pitch_scale = randf_range(0.8,1.2)
		hook_hit_water_1.play()
	else:
		hook_hit_water_2.volume_db = randf_range(-5,0)
		hook_hit_water_2.pitch_scale = randf_range(0.8,1.2)
		hook_hit_water_2.play()

func _on_player_retract_hook() -> void:
	reset_hook()
	sound_picker = randf_range(0,2)
	if sound_picker <= 1:
		hook_hit_water_1.volume_db = randf_range(-5,0)
		hook_hit_water_1.pitch_scale = randf_range(0.8,1.2)
		hook_hit_water_1.play()
	else:
		hook_hit_water_2.volume_db = randf_range(-5,0)
		hook_hit_water_2.pitch_scale = randf_range(0.8,1.2)
		hook_hit_water_2.play()

func _on_fish_spawn_zone_fish_hooked(fish: Variant) -> void:
	reset_hook()
	player.begin_reeling()
	hooked_fish = fish
	hook.visible = false
	sound_picker  = randf_range(0,2)
	if sound_picker <= 1:
		fish_hooked_1.volume_db = randf_range(-5,0)
		fish_hooked_1.pitch_scale = randf_range(0.8,1.2)
		fish_hooked_1.play()
	else:
		fish_hooked_2.volume_db = randf_range(-5,0)
		fish_hooked_2.pitch_scale = randf_range(0.8,1.2)
		fish_hooked_2.play()

func _on_player_reeling() -> void:
	reeling = true

func _on_player_relaxing() -> void:
	reeling = false

func _on_fish_spawn_zone_fish_caught(fish: Variant) -> void:
	stop_reeling_and_reset_fish()
	sound_picker  = randf_range(0,2)
	if sound_picker <= 1:
		fish_caught_1.volume_db = randf_range(-5,0)
		fish_caught_1.pitch_scale = randf_range(0.8,1.2)
		fish_caught_1.play()
	else:
		fish_caught_2.volume_db = randf_range(-5,0)
		fish_caught_2.pitch_scale = randf_range(0.8,1.2)
		fish_caught_2.play()

func _on_player_max_tension() -> void:
	stop_reeling_and_reset_fish()
	sound_picker  = randf_range(0,2)
	if sound_picker <= 1:
		fish_escape_1.volume_db = randf_range(-5,0)
		fish_escape_1.pitch_scale = randf_range(0.8,1.2)
		fish_escape_1.play()
	else:
		fish_escape_2.volume_db = randf_range(-5,0)
		fish_escape_2.pitch_scale = randf_range(0.8,1.2)
		fish_escape_2.play()

func _on_fish_spawn_zone_fish_obstacle_hit(fish: Variant) -> void:
	stop_reeling_and_reset_fish()
	sound_picker  = randf_range(0,2)
	if sound_picker <= 1:
		fish_escape_1.volume_db = randf_range(-5,0)
		fish_escape_1.pitch_scale = randf_range(0.8,1.2)
		fish_escape_1.play()
	else:
		fish_escape_2.volume_db = randf_range(-5,0)
		fish_escape_2.pitch_scale = randf_range(0.8,1.2)
		fish_escape_2.play()

func reset_hook():
	hook.position.x = player.position.x
	hook.position.y = player.position.y
	hook.visible = false

func stop_reeling_and_reset_fish():
	reeling = false
	player.stop_reeling()
	hooked_fish.queue_free()
	fish_spawn_zone.start_fish_spawn_timer()

func play_river_sounds():
	sound_picker = randf_range(0,2)
	if sound_picker <=1:
		river_1.volume_db = randf_range(-10,-5)
		river_1.pitch_scale = randf_range(0.8,1.2)
		river_1.play()
	else:
		river_2.volume_db = randf_range(-10,-5)
		river_2.pitch_scale = randf_range(0.8,1.2)
		river_2.play()

func _on_river_1_finished() -> void:
	play_river_sounds()

func _on_river_2_finished() -> void:
	play_river_sounds()
