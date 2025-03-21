extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hook: Area2D = $Hook
@onready var hook_line: Line2D = $HookLine
@onready var fish_spawn_zone: Area2D = $FishSpawnZone
@onready var audio_player: Node2D = $AudioPlayer

const REELING_SPEED = 100
const HOOK_THROW_SPEED = 10
var normalised_vector
var hook_throw_distance
var hooked_fish: Area2D
var reeling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hook.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hook.visible:
		draw_hook_line(true, hook.position + Vector2(0, -5))
		if hook.position.y > player.position.y - hook_throw_distance+3:
			hook.position.y = lerp(hook.position.y, player.position.y - hook_throw_distance, delta * HOOK_THROW_SPEED)
		else:
			hook.enable_collision(true)
	else:
		draw_hook_line(false)
	
	if hooked_fish != null:
		if reeling:
			normalised_vector = (player.position-hooked_fish.position).normalized()
			hooked_fish.position += normalised_vector * REELING_SPEED * delta
			# TODO: Rotate fish based on player angle + draw hook line to fish head
			print("rotation: " + str(rad_to_deg(normalised_vector.angle())))
			#hooked_fish.rotation = normalised_vector.angle() - deg_to_rad(90) + deg_to_rad(14)
			hooked_fish.rotation = deg_to_rad(14)
			draw_hook_line(true, hooked_fish.position)
		else:
			hooked_fish.position.y -= 50 * delta
			hooked_fish.rotation = deg_to_rad(180 + 14)
			draw_hook_line(true, hooked_fish.position)
		if hooked_fish.position.y < get_viewport_rect().position.y - 50:
			reset_hook()
			stop_reeling_and_reset_fish()
			audio_player.play_random_sound(["FishEscape1", "FishEscape2"])
	
	if !audio_player.is_playing("River1") && !audio_player.is_playing("River2"):
		audio_player.play_random_sound(["River1", "River2"], -10, -5)

func draw_hook_line(visible: bool, to_position: Vector2 = player.position, from_position: Vector2 = player.get_rod_tip_global_position()):
	hook_line.set_point_position(0, from_position)
	hook_line.set_point_position(1, to_position)
	hook_line.visible = visible
	
func _on_player_throw_hook(throw_distance: Variant) -> void:
	hook.position = player.position
	hook_throw_distance = throw_distance
	hook.visible = true
	await get_tree().create_timer(throw_distance/player.MAX_HOOK_THROW_DISTANCE*0.25).timeout
	audio_player.play_random_sound(["HookHitWater1", "HookHitWater2"])

func _on_player_retract_hook() -> void:
	reset_hook()
	audio_player.play_random_sound(["HookHitWater1", "HookHitWater2"])

func _on_fish_spawn_zone_fish_hooked(fish: Variant) -> void:
	reset_hook()
	player.begin_reeling()
	hooked_fish = fish
	hook.visible = false
	audio_player.play_random_sound(["FishHooked1", "FishHooked2"])

func _on_player_reeling() -> void:
	reeling = true

func _on_player_relaxing() -> void:
	reeling = false

func _on_fish_spawn_zone_fish_caught(fish: Variant) -> void:
	stop_reeling_and_reset_fish()
	audio_player.play_random_sound(["FishCaught1", "FishCaught2"])

func _on_player_max_tension() -> void:
	stop_reeling_and_reset_fish()
	audio_player.play_random_sound(["FishEscape1", "FishEscape2"])

func _on_fish_spawn_zone_fish_obstacle_hit(fish: Variant) -> void:
	stop_reeling_and_reset_fish()
	audio_player.play_random_sound(["FishEscape1", "FishEscape2"])

func reset_hook():
	hook.enable_collision(false)
	hook.position.x = player.position.x
	hook.position.y = player.position.y
	hook.visible = false

func stop_reeling_and_reset_fish():
	reeling = false
	player.stop_reeling()
	if hooked_fish != null:
		hooked_fish.queue_free()
	fish_spawn_zone.start_fish_spawn_timer()

func _on_river_1_finished() -> void:
	audio_player.play_random_sound(["River1", "River2"], -10, -5)

func _on_river_2_finished() -> void:
	audio_player.play_random_sound(["River1", "River2"], -10, -5)
