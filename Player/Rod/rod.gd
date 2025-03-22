extends Node2D

@onready var rod: Sprite2D = $Rod
@onready var rod_tip: Sprite2D = $Rod/RodTip
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func play_animation(animation_name: String, animation_speed: float = 1):
	animation_player.speed_scale = animation_speed
	animation_player.play(animation_name)


func seek(percentage: float):
	var length = animation_player.get_animation(animation_player.current_animation).length
	animation_player.seek(length * (1-percentage), true)
	
func set_color(color_vector: Vector3):
	rod.material.set_shader_parameter("replacement_color", color_vector)

func get_rod_tip_global_position() -> Vector2:
	return rod_tip.global_position
