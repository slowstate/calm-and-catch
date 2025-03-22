extends Area2D

signal hit_box_entered


func _on_area_entered(area: Area2D) -> void:
	hit_box_entered.emit()
