extends CenterContainer

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _on_settings_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
