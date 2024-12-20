extends Node3D

@onready var hit_rect = $UI/HitRect
@onready var spawns = $Map/Spawns
@onready var navigation_region = $Map/NavigationRegion3D
@onready var interaction_area: InteractionArea = $InteractionArea

var zombie = load("res://Scenes/Zombie.tscn")
var loloid = load("res://Scenes/Loloid.tscn")
var instance


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	interaction_area.interact = Callable(self, "_on_interact")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_player_hit():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false


func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombie.instantiate()	
	instance.position = spawn_point
	navigation_region.add_child(instance)
	
func _on_wait_to_spawn_loloid_timeout():
	$LoloidSpawnTimer.start()

func _on_loloid_spawn_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = loloid.instantiate()	
	instance.position = spawn_point
	navigation_region.add_child(instance)
	
func _on_interact():
	get_tree().change_scene_to_file("res://Scenes/MapIntroAnimation.tscn")
