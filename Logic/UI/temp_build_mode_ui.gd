extends Button

func _on_pressed() -> void:
	var player:CharacterBody3D = get_tree().get_nodes_in_group("Player")[0]
	player.is_in_build_mode = true
