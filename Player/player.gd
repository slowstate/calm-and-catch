extends CharacterBody2D

@onready var throw_charge_timer: Timer = $ThrowChargeTimer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D

signal throw_hook(throw_distance)
signal retract_hook
signal reeling
signal relaxing
signal max_tension

const SPEED = 15000.0
const MAX_HOOK_THROW_DISTANCE = 500
const MAX_TENSION = 300
const MIN_TENSION = 0

var tension = 0
var raise_tension = false
var shake = 1

func _ready() -> void:
	Global.player = self

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if Input.is_action_pressed("player_move_left"):
		velocity.x = -SPEED * delta
	elif Input.is_action_pressed("player_move_right"):
		velocity.x = SPEED * delta
	else:
		velocity.x = 0
	
	if raise_tension:
		tension += 100 * delta
	else:
		tension = max(tension - 150 * delta, MIN_TENSION)
	if tension >= MAX_TENSION:
		max_tension.emit()
		stop_reeling()
		
	if tension > MAX_TENSION * 0.7:
		shake *= -1
		sprite_2d.position.x += 5 * shake
		
	move_and_slide()

func _on_idle_charge_hook() -> void:
	throw_charge_timer.wait_time = 3
	throw_charge_timer.start()

func _on_idle_throw_hook() -> void:
	var charge_percentage: float = (3 - throw_charge_timer.time_left)/3
	throw_charge_timer.stop()
	var throw_distance = MAX_HOOK_THROW_DISTANCE * charge_percentage
	throw_hook.emit(throw_distance)

func _on_waiting_retract_hook() -> void:
	retract_hook.emit()

func begin_reeling():
	player_state_machine.on_child_transition("Reeling")

func _on_reeling_reeling() -> void:
	raise_tension = true
	reeling.emit()

func _on_reeling_relaxing() -> void:
	raise_tension = false
	relaxing.emit()

func stop_reeling():
	raise_tension = false
	player_state_machine.on_child_transition("Idle")
