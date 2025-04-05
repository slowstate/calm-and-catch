extends Node2D

@onready var bonsai: Area2D = $Bonsai
@onready var guitar: Area2D = $Guitar
@onready var lantern: Area2D = $Lantern

signal bonsaibgm_clicked
signal guitarbgm_clicked

func set_collectible_visibility(collectible_type: Global.Collectible, collectible_visibility: bool):
	match collectible_type:
		Global.Collectible.Bonsai:
			bonsai.visible = collectible_visibility
		Global.Collectible.Guitar:
			guitar.visible = collectible_visibility
		Global.Collectible.Lantern:
			lantern.visible = collectible_visibility


func _on_bonsai_bonsaibgm() -> void:
	bonsaibgm_clicked.emit()

func _on_guitar_guitarbgm() -> void:
	guitarbgm_clicked.emit()
