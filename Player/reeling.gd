class_name Reeling extends State

signal reeling
signal relaxing

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	if Input.is_action_just_pressed("player_primary_action"):
		reeling.emit()
	if Input.is_action_just_released("player_primary_action"):
		relaxing.emit()
