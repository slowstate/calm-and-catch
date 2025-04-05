extends Area2D

var mouse_within_area: bool = false

signal guitarbgm

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if Input.is_action_just_pressed("player_primary_action") && mouse_within_area:
		guitarbgm.emit()


func _on_mouse_entered() -> void:
	mouse_within_area = true


func _on_mouse_exited() -> void:
	mouse_within_area = false
