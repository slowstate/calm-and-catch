extends CharacterBody2D

@onready var throw_charge_timer: Timer = $ThrowChargeTimer
@onready var hook_sprite: Sprite2D = $HookSprite

const SPEED = 30000.0
const MAX_HOOK_THROW_DISTANCE = 500

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

	move_and_slide()

func _on_idle_charge_hook() -> void:
	throw_charge_timer.wait_time = 3
	throw_charge_timer.start()

func _on_idle_throw_hook() -> void:
	var charge_percentage: float = (3 - throw_charge_timer.time_left)/3
	throw_charge_timer.stop()
	var throw_distance = MAX_HOOK_THROW_DISTANCE * charge_percentage
	hook_sprite.position.y = -throw_distance
	hook_sprite.visible = true
	
