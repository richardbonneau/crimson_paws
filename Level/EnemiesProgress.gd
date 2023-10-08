extends Node

@onready var parent:Node3D = self.get_parent()
@onready var enemies_container:Node3D = parent.get_node("Enemies")

var enemies_sorted_by_placement_in_maze:Array[BasicEnemy] = []

func _physics_process(_delta: float) -> void:
	var all_enemies_unfiltered:Array[Node] = enemies_container.get_children()
	var all_enemies:Array[BasicEnemy] = []
	
	# PERFORMANCE: This is just an extra check to make sure we are dealing
	# with enemy nodes. It could theorically be removed for extra performance
	for child in all_enemies_unfiltered:
		if child is BasicEnemy:
			all_enemies.append(child)
	
	all_enemies.sort_custom(sort_enemies_by_placement_in_maze)
	enemies_sorted_by_placement_in_maze = all_enemies

func sort_enemies_by_placement_in_maze(a:BasicEnemy,b:BasicEnemy):
	var a_enemy_nav : EnemyNav = a.get_node("NavigationAgent3D")
	var b_enemy_nav : EnemyNav = b.get_node("NavigationAgent3D")
	
	if a_enemy_nav.waypoint_index > b_enemy_nav.waypoint_index:
		return true
	elif a_enemy_nav.waypoint_index < b_enemy_nav.waypoint_index:
		return false
	else:  # If the waypoint_index is the same, compare by distance_to_next_waypoint
		if a_enemy_nav.distance_to_next_waypoint < b_enemy_nav.distance_to_next_waypoint:
			return true
		elif a_enemy_nav.distance_to_next_waypoint > b_enemy_nav.distance_to_next_waypoint:
			return false
	return false

