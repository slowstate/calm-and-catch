extends Area2D

signal hook_box_entered
signal hook_box_exited

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	hook_box_entered.emit()


func _on_area_exited(area: Area2D) -> void:
	hook_box_exited.emit()
