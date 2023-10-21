extends Node

enum TowerType {
	ARROW = 0,
}

@export var detection_visualizer:PackedScene = preload("res://Towers/TowerCore/DetectionVisualizer.tscn")
@export var tower_database:TowerDatabase = preload("res://Utils/Databases/TowerDatabase/TowerDatabase.tres")

var tower_dictionary:Dictionary = {}

func _init() -> void:
	for tower in tower_database.tower_database:
		tower_dictionary[tower.id] = tower
	print(tower_dictionary)

func get_tower_by_id(id:TowerType)->TowerData:
	return tower_dictionary.get(id, null)

func create_tower_instance(id:TowerType):
	var tower_data:TowerData = get_tower_by_id(id)
	var tower_instance:Node3D = tower_data.scene.instantiate()
	
	# Wait for all nodes to be ready before changing the stats of the instance
	tower_instance.call_deferred("set_stats",tower_data)
	return tower_instance

func create_tower_build_preview(id:TowerType):
	var tower_data:TowerData = get_tower_by_id(id)
	var tower_build_preview_instance:Node3D = tower_data.building_preview_scene.instantiate()
	var detection_visualizer_instance:MeshInstance3D = detection_visualizer.instantiate()
	
	detection_visualizer_instance.set_radius(tower_data.radius)
	tower_build_preview_instance.add_child(detection_visualizer_instance)
	
	return tower_build_preview_instance

