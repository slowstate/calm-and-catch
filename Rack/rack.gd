extends Node2D

@onready var brook_trout_sprite: Sprite2D = $BrookTroutSprite
@onready var brown_trout_sprite: Sprite2D = $BrownTroutSprite
@onready var carp_sprite: Sprite2D = $CarpSprite
@onready var dab_sprite: Sprite2D = $DabSprite
@onready var muskellunge_sprite: Sprite2D = $MuskellungeSprite


func fish_caught(Fish: Global.Fish):
	match Fish:
		Global.Fish.BrookTrout:
			brook_trout_sprite.visible = true
		Global.Fish.BrownTrout:
			brown_trout_sprite.visible = true
		Global.Fish.Carp:
			carp_sprite.visible = true
		Global.Fish.Dab:
			dab_sprite.visible = true
		Global.Fish.Muskellunge:
			muskellunge_sprite.visible = true
	
