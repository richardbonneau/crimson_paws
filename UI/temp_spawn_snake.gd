extends Button

var snake_scene:PackedScene = preload("res://Enemies/EnemyVariants/Snake/Snake.tscn")

func _on_pressed() -> void:
	var start_node : Area3D = get_tree().get_first_node_in_group("Start")
	var enemies_container:Node3D = get_tree().get_first_node_in_group("EnemiesContainer")
	var snake_instance:Node3D = snake_scene.instantiate()
	
	enemies_container.add_child(snake_instance)
	snake_instance.global_transform.origin = start_node.global_transform.origin
