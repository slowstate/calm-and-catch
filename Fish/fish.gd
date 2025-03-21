extends Area2D

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
var shake_speed = 5
var shake = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_fish_type()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !hooked_timer.is_stopped():
		shake *= -1
		position.x += 5 * shake

func set_fish_type():
	var random_int = randi_range(1,100)
	if random_int <= 5: # 5% chance
		fish_type = Global.Fish.Muskellunge
		speed = 80
	elif random_int <= 15: # 10% chance
		fish_type = Global.Fish.Dab
		speed = 70
	elif random_int <= 30: # 15% chance
		fish_type = Global.Fish.Carp
		speed = 70
	elif random_int <= 60: # 30% chance
		fish_type = Global.Fish.BrownTrout
		speed = 50
	else: # 40% chance
		fish_type = Global.Fish.BrookTrout
		speed = 50

func get_fish_head_global_position() -> Vector2:
	return fish_head.global_position

func _on_hooked_timer_timeout() -> void:
	hooked.emit(self)
	hook_box.monitoring = false
	hit_box.monitoring = true
	sprite_animation.play("fish hooked")

func _on_body_entered(body: Node2D) -> void:
	caught.emit(self)

func _on_hook_box_hook_box_entered() -> void:
	hooked_timer.wait_time = randi_range(2, 4)
	hooked_timer.start()
	# TODO: Play hooking animation

func _on_hook_box_hook_box_exited() -> void:
	# TODO: Stop the hooking animation
	hooked_timer.stop()

func _on_hit_box_hit_box_entered() -> void:
	obstacle_hit.emit(self)
