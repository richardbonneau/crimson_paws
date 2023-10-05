extends Node3D

var projectile_scene = preload("res://Level/Towers/Projectile/Projectile.tscn")

@export var attack_speed:float = 0.5

var damage:int = 3

@onready var shootCooldownTimer = $ShootCooldownTimer
@onready var targetList = $TargetList

func _ready():
	set_attack_speed(attack_speed)

func set_attack_speed(new_attack_speed:float):
	attack_speed = new_attack_speed
	shootCooldownTimer.set_wait_time(new_attack_speed)

func set_target_and_shoot(new_target:Node3D):
	print(targetList)
	print(targetList.current_target)
	targetList.current_target = new_target
	
	if shootCooldownTimer.time_left == 0:
		shoot_at_enemy()

func shoot_at_enemy(): 
	# Create and Append Projectile to scene
	var projectile:Node3D = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_transform.origin = self.global_transform.origin
	
	projectile.seek_and_destroy_target(targetList.current_target, damage)
	
	shootCooldownTimer.start()

func _on_ShootCooldownTimer_timeout():
	var _current_target = targetList.current_target
	if is_instance_valid(_current_target) and _current_target.current_health > 0:
		shoot_at_enemy()
	else:
		_current_target = null
