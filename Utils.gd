extends Node

func instance_scene_on_main(scene, position):
	var main = get_tree().current_scene
	var instance = scene.instance()	
	instance.global_position = position
	main.add_child(instance)
	return instance

