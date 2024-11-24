extends Node3D

@onready var player
@onready var label = $Label3D

const base_text = "[F] to"

var active_areas = []
var can_interact = true

func _ready():
	player = get_tree().get_first_node_in_group("player")

func register_area(area: InteractionArea):
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	var index = active_areas.find(area)
	if index != -1:
		active_areas.remove_at(index)
		
func _process(delta):
	if active_areas.size() > 0 && can_interact:
		label.text = base_text + active_areas[0].popup_text
		label.global_position = active_areas[0].global_position
		label.global_position.y += 36
		label.show()
	else:
		label.hide

func _input(event):
	if event.is_action_pressed("interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false
			label.hide()
			
			await active_areas[0].interact.call()
			
			can_interact = true
