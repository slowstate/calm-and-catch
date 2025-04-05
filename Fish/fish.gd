extends Area2D

@onready var fade_in_timer: Timer = $FadeInTimer
@onready var hooked_timer: Timer = $HookedTimer
@onready var hook_box: Area2D = $HookBox
@onready var hit_box: Area2D = $HitBox
@onready var sprite_animation: AnimatedSprite2D = $SpriteAnimation
@onready var fish_head: Sprite2D = $SpriteAnimation/FishHead

const BROOK_TROUT = preload("res://Fish/Brook_Trout.png")
const BROWN_TROUT = preload("res://Fish/Brown_Trout.png")
const CARP = preload("res://Fish/Carp.png")
const DAB = preload("res://Fish/Dab.png")
const MUSKELLUNGE = preload("res://Fish/Muskellunge.png")

signal caught(fish)
signal hooked(fish)
signal obstacle_hit(fish)

var fish_type: Global.Fish = Global.Fish.BrookTrout
var speed = 50
var sprite_to_hook_vector
var head_to_hook_vector
var hook_global_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_fish_type()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sprite_animation.modulate.a = 1-fade_in_timer.time_left/fade_in_timer.wait_time
	
	if !hooked_timer.is_stopped():
		sprite_animation.global_position += head_to_hook_vector/hooked_timer.wait_time * delta


func set_fish_type():
	var random_int = randi_range(1,100)
	if random_int <= 100: # 5% chance
		sprite_animation.speed_scale = 1.7
		fish_type = Global.Fish.Muskellunge
		speed = 80
	elif random_int <= 15: # 10% chance
		sprite_animation.speed_scale = 1.2
		fish_type = Global.Fish.Dab
		speed = 70
	elif random_int <= 30: # 15% chance
		sprite_animation.speed_scale = 1.2
		fish_type = Global.Fish.Carp
		speed = 70
	elif random_int <= 60: # 30% chance
		sprite_animation.speed_scale = 1
		fish_type = Global.Fish.BrownTrout
		speed = 50
	else: # 40% chance
		sprite_animation.speed_scale = 1
		fish_type = Global.Fish.BrookTrout
		speed = 50

func get_fish_head_global_position() -> Vector2:
	return fish_head.global_position

func _on_hooked_timer_timeout() -> void:
	global_position = hook_global_position
	hooked.emit(self)
	hook_box.monitoring = false
	hit_box.monitoring = true
	sprite_animation.play("fish hooked")
	sprite_animation.rotation = deg_to_rad(14) # Default rotation
	

func _on_body_entered(_body: Node2D) -> void:
	caught.emit(self)

func _on_hook_box_hook_box_entered(area: Area2D) -> void:
	hooked_timer.wait_time = randi_range(2, 4)
	hooked_timer.start()
	sprite_animation.play("fish hooked")
	hook_global_position = area.global_position
	sprite_to_hook_vector = Vector2(area.global_position - sprite_animation.global_position)
	sprite_animation.rotation = sprite_to_hook_vector.angle() - deg_to_rad(90) + deg_to_rad(14)
	head_to_hook_vector = Vector2(area.global_position - fish_head.global_position)

func _on_hook_box_hook_box_exited() -> void:
	hooked_timer.stop()
	sprite_animation.play("default")
	sprite_animation.rotation = deg_to_rad(14) # Default rotation
	sprite_animation.global_position = global_position

func _on_hit_box_hit_box_entered() -> void:
	obstacle_hit.emit(self)

func set_night_mode(is_enabled: bool):
	if is_enabled:
		sprite_animation.modulate = Color(8, 8, 8, 1)
	else:
		sprite_animation.modulate = Color(1, 1, 1, 1)
