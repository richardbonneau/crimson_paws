extends Node

@onready var scene_root:CharacterBody3D = get_parent()

func _on_death_timer_timeout():
	scene_root.queue_free()
