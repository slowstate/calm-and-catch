extends Area2D

signal hook_box_entered
signal hook_box_exited


func _on_area_entered(area: Area2D) -> void:
	hook_box_entered.emit()


func _on_area_exited(area: Area2D) -> void:
	hook_box_exited.emit()
