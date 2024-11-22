class_name Player

extends CharacterBody3D

const SENSITIVITY = 0.001
const HIT_STAGGER = 8.0

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

#fov variables
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# signal
signal player_hit
signal health_changed
signal ability_granted(ability: Ability)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Bullets
var bullet = load("res://Scenes/Bullet.tscn")
var instance

# Player Stats
var speed
const WALK_SPEED = 8.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.5
var CURRENT_HEALTH: float = 20.0
var MAX_HEALTH: float = 20.0
var ZOMBIE_KILLS = 0.0
var ACTIVE_ABILITY : Ability = null

# Abilities
var ability_inventory: Array = []

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_anim = $Head/Camera3D/Rifle/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Rifle/RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 15.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 15.0)
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	# Head bob
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	# Shooting
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("Shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
	
	# Abilities
	if Input.is_action_just_pressed("activate_ability"):
		ACTIVE_ABILITY.applya(self)
	
	move_and_slide()


func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos

func hit(dir):
	player_hit.emit()
	velocity += dir * HIT_STAGGER
	CURRENT_HEALTH -= 2
	health_changed.emit(CURRENT_HEALTH)
	MusicManager.get_child(1).play()
	if CURRENT_HEALTH <= 0:
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
	await get_tree().create_timer(10).timeout
	MusicManager.get_child(1).stop()
	
# Function to add an ability to the player's inventory
func grant_ability(ability: Ability):
	# Add the ability to the player's inventory
	ability_inventory.append(ability)

	# Optionally print out to console for debugging
	send_message("Ability unlocked: " + ability.ability_name)
	print("Picked up ability: ", ability.ability_name)

	# Emit a signal that the player has acquired a new ability (if needed)
	emit_signal("ability_granted", ability)

	# If the ability is active (like Fireball), you can immediately activate it
	if ability.ability_name == "Fireball":
		start_fireball(ability.fireball_damage, ability.fireball_speed)

# Send a message to the player (e.g., displaying it in a UI element)
func send_message(message: String):
	# Assuming you have a Label in the UI to display messages
	var message_label = $UI/TitleMessage
	message_label.text = message
	# Optionally, you can make it disappear after a short duration
	message_label.show()
	await get_tree().create_timer(2.0).timeout
	message_label.hide()

# Function to handle Fireball ability (example)
func start_fireball(damage: float, speed: float):
	# Logic for firing the fireball
	print("Firing fireball with damage:", damage, "and speed:", speed)
	# Instantiate and shoot the fireball, etc.
	
func _on_ability_granted(ability):
	ACTIVE_ABILITY = ability

func add_to_health(amount: float):
	CURRENT_HEALTH += amount
	player_hit.emit()
	
func add_to_counter():
	ZOMBIE_KILLS+=1
	$UI/KillCounter.text = str(ZOMBIE_KILLS)
