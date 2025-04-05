extends Area2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var col_hook_box_2: Area2D = $ColHookBox2
@onready var col_hit_box_2: Area2D = $ColHitBox2


const BONSAI = preload("res://Collectibles/Bonsai.png")
const GUITAR = preload("res://Collectibles/Guitar.png")
const LANTERN = preload("res://Collectibles/Lantern.png")

var speed
var original_position: Vector2
var random_offset
var collectible_type: Global.Collectible = Global.Collectible.Bonsai

signal caught(collectible)
signal hooked(collectible)
signal obstacle_hit(collectible)
var is_being_reeled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collectible_type()
	speed = randi_range(25, 35)
	original_position = Vector2(position.x,position.y)
	random_offset = randi_range(0, 99)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_being_reeled:
		position.x += speed * delta
		position.y = original_position.y + sin(Time.get_unix_time_from_system() + random_offset) * 6

func set_collectible_type():
	var remaining_collectibles: Array = Global.Collectible.values().duplicate()
	
	for collectible in Global.CollectiblesCaught:
		if remaining_collectibles.has(collectible):
			remaining_collectibles.erase(collectible)
	
	collectible_type = remaining_collectibles.pick_random()
	
	match collectible_type:
		Global.Collectible.Bonsai:
			sprite_2d.texture = BONSAI
			sprite_2d.scale = Vector2(0.3, 0.3)
		Global.Collectible.Guitar:
			sprite_2d.texture = GUITAR
			sprite_2d.scale = Vector2(0.6, 0.6)
		Global.Collectible.Lantern:
			sprite_2d.texture = LANTERN
			sprite_2d.scale = Vector2(0.6, 0.6)


func _on_despawn_timer_timeout() -> void:
	queue_free()


func _on_col_hook_box_2_area_entered(_area: Area2D) -> void:
	is_being_reeled = true
	col_hook_box_2.monitoring = false
	col_hit_box_2.monitoring = true
	hooked.emit(self)


func _on_col_hit_box_2_area_entered(_area: Area2D) -> void:
	obstacle_hit.emit(self)


func _on_body_entered(_body: Node2D) -> void:
	if !Global.CollectiblesCaught.has(collectible_type):
		Global.CollectiblesCaught.push_back(collectible_type)
	caught.emit(self)
