class_name Abil extends Resource

@export var ability_name: String = "Default Ability"
@export var rarity: String = "Common"
@export var color: Color = Color.WHITE
@export var spawn_object: PackedScene
@export var effect_power: float = 1.0
@export var despawn_time: float = 4.0

func activate(player: Node):
	pass
