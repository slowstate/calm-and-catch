extends Node2D

@onready var target: Node2D = $Node2D/Target
@onready var rod_tip: Sprite2D = $"Body/1/RodTip"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation(animation_name: String, animation_speed: float = 1):
	animation_player.speed_scale = animation_speed
	animation_player.play(animation_name)

func seek(percentage: float):
	var length = animation_player.get_animation(animation_player.current_animation).length
	animation_player.seek(length * (1-percentage), true)

func get_rod_tip_global_position() -> Vector2:
	return rod_tip.global_position

func set_target(target_position: Vector2):
	target.global_position = target_position

func reset_target():
	target.position = Vector2(9, -436)
