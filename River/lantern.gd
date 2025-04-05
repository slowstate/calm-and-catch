extends Area2D

@onready var night_mode: Node2D = $Lantern/NightMode

signal enable_night_mode(is_enabled: bool)

var mouse_within_area: bool = false

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("player_primary_action") && mouse_within_area:
		night_mode.visible = !night_mode.visible
		enable_night_mode.emit(night_mode.visible)


func _on_mouse_entered() -> void:
	mouse_within_area = true


func _on_mouse_exited() -> void:
	mouse_within_area = false
