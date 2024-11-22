extends Ability

@export var heal_amount: float = 2.0

func apply(player: Player) -> void:
	player.add_to_health(heal_amount)
