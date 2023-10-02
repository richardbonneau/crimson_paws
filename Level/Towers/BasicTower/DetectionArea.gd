extends Area3D

@onready var shooting_node: Node3D = get_parent().get_parent().get_node("Shooting")

func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		shooting_node.shoot_at_enemy(body)
		pass
		print("enter")
		print(body)



func _on_body_exited(body):
	if body.is_in_group("Enemy"):
		pass
#		print("exit")
#		print(body)
