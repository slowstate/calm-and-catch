extends CharacterBody2D

@onready var throw_charge_timer: Timer = $ThrowChargeTimer
@onready var player_state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var walking_sfx: AudioStreamPlayer2D = $WalkingSFX
@onready var rod_throw_short: AudioStreamPlayer2D = $RodThrowShort
#@onready var rod_throw_medium: AudioStreamPlayer2D = $RodThrowMedium
@onready var rod_throw_long: AudioStreamPlayer2D = $RodThrowLong
@onready var reeling_sfx: AudioStreamPlayer2D = $ReelingSFX
@onready var character_animation: Node2D = $"Character Animation"

signal throw_hook(throw_distance)
signal retract_hook
signal reeling
signal relaxing
signal max_tension

const SPEED = 5000.0
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
		character_animation.play_animation("Walk_Left")
	elif Input.is_action_pressed("player_move_right"):
		velocity.x = SPEED * delta
		character_animation.play_animation("Walk_Right")
	else:
		velocity.x = 0
		character_animation.play_animation("Idle")
		#walking_sfx.stop()
	
	#Walking sound effects
	if velocity.x != 0:
		if !walking_sfx.playing:
			walking_sfx.play()
	elif walking_sfx.playing:
		walking_sfx.stop()
	

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
	if throw_distance <= 1.5:
		rod_throw_short.volume_db = randf_range(-5,0)
		rod_throw_short.pitch_scale = randf_range(0.9,1.1)
		rod_throw_short.play()
	else:
		rod_throw_long.volume_db = randf_range(-5,0)
		rod_throw_long.pitch_scale = randf_range(0.9,1.1)
		rod_throw_long.play()

func _on_waiting_retract_hook() -> void:
	retract_hook.emit()

func begin_reeling():
	player_state_machine.on_child_transition("Reeling")

func _on_reeling_reeling() -> void:
	raise_tension = true
	reeling.emit()
	if !reeling_sfx.playing:
		reeling_sfx.play()
	

func _on_reeling_relaxing() -> void:
	raise_tension = false
	relaxing.emit()
	if reeling_sfx.playing:
		reeling_sfx.stop()

func stop_reeling():
	raise_tension = false
	player_state_machine.on_child_transition("Idle")
	if reeling_sfx.playing:
		reeling_sfx.stop()
