extends Ability

@export var heal_amount: float = 2.0

func apply(player: Player) -> void:
	# Check if the player has this ability in their inventory
	if not self.unique_id in player.ability_inventory:
		player.send_message("You do not have this ability in your inventory.")
		return

	# Check if there are enough uses of this ability in the inventory
	if player.ability_inventory[self.unique_id] <= 0:
		player.send_message("No more uses left for: " + self.ability_name)
		return

	# Check if the player is already at maximum health
	if player.CURRENT_HEALTH >= player.MAX_HEALTH:
		player.send_message("You are already at maximum health.")
		return

	# Deduct one use of the ability from the inventory
	player.ability_inventory[self.unique_id] -= 1

	# Add the heal amount to the player's health
	player.add_to_health(heal_amount)

	# Notify the player of successful usage
	player.send_message("Ability used! Healed for " + str(heal_amount) + ". 
	Remaining: " + str(player.ability_inventory[self.unique_id]))
