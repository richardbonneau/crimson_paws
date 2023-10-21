extends Node

enum EnemyType {
	SNAKE = 0,
	HYDRA = 1
}

var enemy_database:EnemyDatabase = preload("res://Utils/Databases/EnemyDatabase.tres")
var enemy_dictionary:Dictionary = {}

func _init() -> void:
	for enemy in enemy_database.enemy_database:
		enemy_dictionary[enemy.id] = enemy

func get_enemy_by_id(id:EnemyType)->EnemyData:
	# Modifiy the packed scene with the data from the tres
	return enemy_dictionary.get(id, null)

func create_enemy_instance_from_dictionary(id:EnemyType):
	var enemy_data:EnemyData = get_enemy_by_id(id)
	var enemy_instance:Node3D = enemy_data.scene.instantiate()
	
	# Wait for all nodes to be ready before changing the stats of the instance
	enemy_instance.call_deferred("set_stats",enemy_data)
	return enemy_instance

