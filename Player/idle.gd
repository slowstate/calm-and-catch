class_name Idle extends State
@onready var throw_charge_timer: Timer = $"../../ThrowChargeTimer"

signal charge_hook
signal throw_hook
var charging = true

func enter() -> void:
	pass
	
func exit() -> void:
	pass
	
func update(_delta: float) -> void:
	pass
	
func physics_update(_delta: float) -> void:
	#print("Throw timer, time left: " + str(throw_charge_timer.time_left))
	# Throw hook.
	if Input.is_action_just_pressed("player_primary_action") && Global.player.rod_controllable:
		charge_hook.emit()
		charging = true
	if Input.is_action_just_released("player_primary_action") && charging && Global.player.rod_controllable:
		throw_hook.emit()
		transition.emit("Waiting")
		charging = false
