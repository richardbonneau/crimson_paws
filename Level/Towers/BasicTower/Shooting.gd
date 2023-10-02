extends Node3D

var projectile_scene = preload("res://Level/Towers/Projectile/Projectile.tscn")
# Called when the node enters the scene tree for the first time.

func shoot_at_enemy(enemy):
	var projectile:Node3D = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_transform.origin = self.global_transform.origin
	projectile.set_target_and_shoot(enemy)
	
	
