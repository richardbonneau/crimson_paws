extends Area3D

@onready var shooting_node: Node3D = get_parent().get_parent()

var enemies_in_range:Array[Node3D] = []

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.append(body)
		shooting_node.change_in_enemy_in_range()

func _on_body_exited(body):
	if body.is_in_group("Enemy"):
		enemies_in_range.erase(body)
		shooting_node.change_in_enemy_in_range()

