extends CenterContainer

var main_scene = preload("res://Scenes/World.tscn")

func _on_start_pressed():
	MusicManager.get_child(0).play()
	get_tree().change_scene_to_packed(main_scene)
	
func _on_quit_pressed():
	get_tree().quit()
