extends Control

var fade = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fade && modulate.a > 0:
		modulate.a -= delta/3


func _on_controls_timer_timeout() -> void:
	fade = true
