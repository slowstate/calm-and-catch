extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var hook: Area2D = $Hook
@onready var hook_line: Line2D = $HookLine
@onready var fish_spawn_zone: Area2D = $FishSpawnZone
@onready var audio_player: Node2D = $AudioPlayer
@onready var rack: Node2D = $Rack

const REELING_SPEED = 100
const HOOK_THROW_SPEED = 10
var normalised_vector
var hook_throw_distance
var hooked_fish: Area2D
var reeling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hook.visible = false
	audio_player.play_sound("BGM",10,10,1,1)
	audio_player.play_sound("Wildlife",-5,5,.9,1.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hook.visible:
		player.set_rod_bend_target(hook.position)
		draw_hook_line(true, hook.position + Vector2(0, -5))
		if hook.position.y > player.position.y - hook_throw_distance+3:
			hook.position.y = lerp(hook.position.y, player.position.y - hook_throw_distance, delta * HOOK_THROW_SPEED)
		else:
			hook.enable_collision(true)
			hook.set_bobbing(true)
	else:
		hook.set_bobbing(false)
		draw_hook_line(false)
	
	if hooked_fish != null:
		player.set_rod_bend_target(hooked_fish.position)
		if reeling:
			normalised_vector = (player.position-hooked_fish.position).normalized()
			hooked_fish.position += normalised_vector * REELING_SPEED * delta
			hooked_fish.rotation = normalised_vector.angle() - deg_to_rad(90) + deg_to_rad(14)
			draw_hook_line(true, hooked_fish.get_fish_head_global_position())
		else:
			hooked_fish.position.y -= hooked_fish.speed * delta
			hooked_fish.rotation = deg_to_rad(180 + 14)
			draw_hook_line(true, hooked_fish.get_fish_head_global_position())
		if hooked_fish.position.y < get_viewport_rect().position.y - 50:
			reset_hook()
			stop_reeling_and_reset_fish()
			audio_player.play_random_sound(["FishEscape1", "FishEscape2"])
	
	if !audio_player.is_playing("River1") && !audio_player.is_playing("River2"):
		audio_player.play_random_sound(["River1", "River2"], -20, -10)

func draw_hook_line(visible: bool, to_position: Vector2 = hook.position, from_position: Vector2 = player.get_rod_tip_global_position()):
	hook_line.set_point_position(0, from_position)
	hook_line.set_point_position(1, to_position)
	
	# Colour of hook line starts with white and gradually turns yellow > red by subtracting the below rgb values
	hook_line.default_color = Color.WHITE - Color(
		lerp(0.0, 0.3, pow(player.tension/player.MAX_TENSION, 5)),
		lerp(0, 1, pow(player.tension/player.MAX_TENSION, 5)),
		lerp(0, 1, pow(player.tension/player.MAX_TENSION, 2)), 0)
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
	player.begin_reeling(fish.fish_type)
	hooked_fish = fish
	hook.visible = false
	audio_player.play_random_sound(["FishHooked1", "FishHooked2"])

func _on_player_reeling() -> void:
	reeling = true

func _on_player_relaxing() -> void:
	reeling = false

func _on_fish_spawn_zone_fish_caught(fish: Variant) -> void:
	rack.fish_caught(fish.fish_type)
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
