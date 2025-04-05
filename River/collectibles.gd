extends Node2D

@onready var bonsai: Area2D = $Bonsai
@onready var guitar: Area2D = $Guitar
@onready var lantern: Area2D = $Lantern

func set_collectible_visibility(collectible_type: Global.Collectible, is_visible: bool):
	match collectible_type:
		Global.Collectible.Bonsai:
			bonsai.visible = is_visible
		Global.Collectible.Guitar:
			guitar.visible = is_visible
		Global.Collectible.Lantern:
			lantern.visible = is_visible
