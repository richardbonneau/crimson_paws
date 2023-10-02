extends Node3D

var projectile_scene = preload("res://Level/Towers/Projectile/Projectile.tscn")

@export var attack_speed:float = 1.0

var _current_target:Node3D
var damage:int = 3

func _ready():
	set_attack_speed(attack_speed)

func set_attack_speed(new_attack_speed:float):
	attack_speed = new_attack_speed
	$Timer.set_wait_time(new_attack_speed)

func set_target_and_shoot(new_target:Node3D):
	_current_target = new_target
	shoot_at_enemy()
	$Timer.start()

func shoot_at_enemy():
	if _current_target:
		var projectile:Node3D = projectile_scene.instantiate()
		get_tree().root.add_child(projectile)
		projectile.global_transform.origin = self.global_transform.origin
		projectile.seek_and_destroy_target(_current_target, damage)



func _on_timer_timeout():
	if is_instance_valid(_current_target) and _current_target.current_health > 0:
		shoot_at_enemy()
		$Timer.start()
	else:
		_current_target = null
