extends CharacterBody3D

var player = null
var state_machine
var health = 5

const SPEED = 4.0
const ATTACK_RANGE = 2.0

@export var player_path := "/root/World/Map/NavigationRegion3D/Player"
@export var ability_drop_chance: float = 0.5
@export var available_abilities: Array = []

@onready var particles = $GPUParticles3D
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Run":
			# Navigation
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
		"Attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	# Conditions
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	
	move_and_slide()


func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

func _on_area_3d_body_part_hit(dam):
	particles.emitting = true
	health -= dam
	if health <= 0:
		_on_death()
		
func _on_death():
	anim_tree.set("parameters/conditions/die", true)
	player.add_to_counter()
	await get_tree().create_timer(4.0).timeout
	queue_free()
	_drop_ability()
	
# Drop an ability as an AbilityPickup
func _drop_ability():
	if available_abilities.size() > 0:
		var random_ability = available_abilities[randi() % available_abilities.size()]
		var ability = random_ability.instantiate()
		
		# Instantiate AbilityPickup and assign the random ability to it
		var ability_pickup = preload("res://Scenes/abilities/PickupAbility.tscn").instantiate()
		
		# Set the ability for the pickup (you might want to store the ability inside the pickup)
		ability_pickup.set_ability(ability)
		
		ability_pickup.global_transform.origin = global_transform.origin  # Place it at the zombie's location
		get_tree().current_scene.add_child(ability_pickup)
		
		print("Zombie dropped an ability pickup:", ability.ability_name)
