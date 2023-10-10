extends Node3D

var projectile_scene:PackedScene = preload("res://Level/Towers/Projectile/Projectile.tscn")

@export var attack_speed:float = 0.5

@onready var parent:Node3D = get_parent()
@onready var shooting_cooldown_bar:Sprite3D = parent.get_node("ProgressBar3D")
@onready var shootCooldownTimer:Timer = $ShootCooldownTimer
@onready var enemies_positions_in_maze_node = get_tree().get_nodes_in_group("EnemiesPositionsInMaze")[0]

var damage:int = 1
var current_target:Node3D

func _ready()-> void:
	set_attack_speed(attack_speed)
	shooting_cooldown_bar.set_max_value(100)

func _process(delta:float)->void:
	shooting_cooldown_bar.set_value(100 - (shootCooldownTimer.time_left * 100) / attack_speed)

func set_attack_speed(new_attack_speed:float) -> void:
	attack_speed = new_attack_speed
	shootCooldownTimer.set_wait_time(new_attack_speed)

func find_enemy_in_range_furthest_in_maze(enemies_in_range:Array[Node3D]):
	var enemies_positions_in_maze = enemies_positions_in_maze_node.enemies_sorted_by_placement_in_maze
	for enemy in enemies_positions_in_maze:
		if enemies_in_range.has(enemy):
			return enemy
	return null

func set_target_and_shoot(enemies_in_range:Array[Node3D]):
	current_target = find_enemy_in_range_furthest_in_maze(enemies_in_range)
	print(current_target)
	if shootCooldownTimer.time_left == 0:
		shoot_at_enemy()

func shoot_at_enemy() -> void: 
	# Create and Append Projectile to scene
	var projectile:Node3D = projectile_scene.instantiate()
	get_tree().root.add_child(projectile)
	projectile.global_transform.origin = self.global_transform.origin
	
	projectile.seek_and_destroy_target(current_target, damage)
	shootCooldownTimer.start()

func _on_ShootCooldownTimer_timeout()->void:
	if is_instance_valid(current_target) and current_target.health.current_health > 0:
		shoot_at_enemy()
	else:
		current_target = null
		shootCooldownTimer.stop()