extends Area3D

@export var ability: Ability  # Reference to the ability scene

@onready var label = $Label3D  # Assuming you have a Label to display ability name or info
@onready var mesh = $MeshInstance3D

@export var player_path := "/root/World/Map/NavigationRegion3D/Player"
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get the player from the specified path
	player = get_node(player_path)
	
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	label.text = ability.ability_name
	label.modulate = ability.color

func set_ability(ability_scene: Ability):
	ability = ability_scene

# Function triggered when something enters the pickup area
func _on_body_entered(body: Node) -> void:
	# Check if the body that entered is the player
	if body.is_in_group("player"):  # Assuming your player is part of the "Player" group
		# Grant the ability to the player
		player.grant_ability(ability)  # Add the ability to the player's inventory

		# Send a message to the player (You can replace this with an in-game UI message system)
		player.send_message("Picked up: " + ability.ability_name)

		# Optionally, destroy the ability pickup after it is picked up
		queue_free()  # Remove the ability pickup from the scene
