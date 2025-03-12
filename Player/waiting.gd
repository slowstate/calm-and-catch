class_name Waiting extends State

signal retract_hook

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if Input.is_action_pressed("player_primary_action"):
		print("Retract hook")
		retract_hook.emit()
		transition.emit("Idle")
