extends Node2D

@onready var brook_trout_sprite: Sprite2D = $BrookTroutSprite
@onready var brown_trout_sprite: Sprite2D = $BrownTroutSprite
@onready var carp_sprite: Sprite2D = $CarpSprite
@onready var dab_sprite: Sprite2D = $DabSprite
@onready var muskellunge_sprite: Sprite2D = $MuskellungeSprite
@onready var shake_timer: Timer = $ShakeTimer

var is_shaking = false
var shake = 1
var last_caught_fish: Sprite2D
var last_caught_fish_original_position: Vector2

func _process(delta: float) -> void:
	if is_shaking:
		shake *= -1
		last_caught_fish.position.x += 2 * shake

func fish_caught(Fish: Global.Fish):
	match Fish:
		Global.Fish.BrookTrout:
			brook_trout_sprite.visible = true
			last_caught_fish = brook_trout_sprite
		Global.Fish.BrownTrout:
			brown_trout_sprite.visible = true
			last_caught_fish = brown_trout_sprite
		Global.Fish.Carp:
			carp_sprite.visible = true
			last_caught_fish = carp_sprite
		Global.Fish.Dab:
			dab_sprite.visible = true
			last_caught_fish = dab_sprite
		Global.Fish.Muskellunge:
			muskellunge_sprite.visible = true
			last_caught_fish = muskellunge_sprite
	last_caught_fish_original_position = last_caught_fish.position
	is_shaking = true
	shake_timer.wait_time = 1
	shake_timer.start()

func _on_shake_timer_timeout() -> void:
	last_caught_fish.position = last_caught_fish_original_position
	is_shaking = false
