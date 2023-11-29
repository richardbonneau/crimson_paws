extends Node

enum EnemyType {
	SNAKE = 0,
	HYDRA = 1
}

var enemy_dictionary:Dictionary = {}
var enemies_data_folder_path:String = "res://Data/Enemies/"

func _init() -> void:
	var all_enemies:Array = CustomFunctions.load_resources_from_folder(enemies_data_folder_path)
	for enemy in all_enemies:
		enemy_dictionary[enemy.id] = enemy

func get_enemy_data_by_id(id:EnemyType)->EnemyData:
	return enemy_dictionary.get(id, null)

func create_enemy_instance(id:EnemyType):
	var enemy_data:EnemyData = get_enemy_data_by_id(id)
	var enemy_instance:Node3D = enemy_data.scene.instantiate()
	
	# Wait for all nodes to be ready before changing the stats of the instance
	enemy_instance.call_deferred("set_stats",enemy_data)
	return enemy_instance

