extends Area2D

@onready var effects: Node2D = $Effects

var mouse_within_area: bool = false

signal bonsaibgm()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("player_primary_action") && mouse_within_area:
		effects.visible = !effects.visible
		if effects.visible:
			bonsaibgm.emit()


func _on_mouse_entered() -> void:
	mouse_within_area = true


func _on_mouse_exited() -> void:
	mouse_within_area = false
