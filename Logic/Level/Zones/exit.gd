extends Area3D
class_name ExitZone

func _ready():
	print("exit loc ",self.global_transform.origin)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Enemy"):
		var enemy_data:EnemyData = EnemyDictionary.get_enemy_data_by_id(body.id)
		var lives_to_remove:int = enemy_data.life_cost
		Player.remove_lives(lives_to_remove)
		body.queue_free()
