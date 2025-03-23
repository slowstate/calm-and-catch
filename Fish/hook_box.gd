extends Area2D

signal hook_box_entered(area: Area2D)
signal hook_box_exited


func _on_area_entered(area: Area2D) -> void:
	hook_box_entered.emit(area)


func _on_area_exited(_area: Area2D) -> void:
	hook_box_exited.emit()
