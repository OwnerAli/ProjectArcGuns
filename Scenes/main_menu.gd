extends CenterContainer

var main_scene = preload("res://Scenes/World.tscn")

func _on_start_pressed():
	MenuMusic.stop()
	MusicManager.get_child(0).play()
	get_tree().change_scene_to_packed(main_scene)

func _on_settings_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()

func _on_start_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_settings_mouse_entered():
	$AudioStreamPlayer2D.play()

func _on_quit_mouse_entered():
	$AudioStreamPlayer2D.play()
