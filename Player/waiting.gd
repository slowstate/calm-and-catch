class_name Waiting extends State

signal retract_hook

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	if Input.is_action_pressed("player_primary_action") && Global.player.rod_controllable:
		retract_hook.emit()
		transition.emit("Idle")
