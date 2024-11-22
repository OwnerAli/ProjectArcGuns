class_name Ability extends Node

@export var ability_name: String = "Default Ability"
@export var rarity: String = "Common"
@export var spawn_rarity: float = 90
@export var color: Color = Color.WHITE
@export var spawn_object: Area3D
@export var effect_power: float = 1.0
@export var despawn_time: float = 3.0

func apply(player):
	pass
