extends TextureProgressBar

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.player_hit.connect(update)
	update()

func update():
	value = player.CURRENT_HEALTH * 100 / player.MAX_HEALTH
