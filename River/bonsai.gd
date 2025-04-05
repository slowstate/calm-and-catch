extends Area2D

@onready var effects: Node2D = $Effects

var mouse_within_area: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("player_primary_action") && mouse_within_area:
		effects.visible = !effects.visible


func _on_mouse_entered() -> void:
	mouse_within_area = true


func _on_mouse_exited() -> void:
	mouse_within_area = false
