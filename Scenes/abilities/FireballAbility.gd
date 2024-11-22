extends Ability

@export var fireball_damage: float = 20.0
@export var fireball_speed: float = 10.0

func apply(player: Player) -> void:
	print("Spawned a fireball with damage: ", fireball_damage)
