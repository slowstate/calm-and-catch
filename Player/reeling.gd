class_name Reeling extends State

signal reeling
signal relaxing

func enter() -> void:
	print("Player Reeling")
	pass
	
func exit() -> void:
	pass
	
func update(delta: float) -> void:
	pass
	
func physics_update(delta: float) -> void:
	if Input.is_action_just_pressed("player_primary_action"):
		reeling.emit()
	if Input.is_action_just_released("player_primary_action"):
		relaxing.emit()
