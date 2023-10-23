extends Area3D
class_name StartZone

var debug_mesh:PackedScene = preload("res://Utils/Debug/DebugMesh.tscn")

@export var debug:bool = false
@export var td_maze_corners = []

# Called when the node enters the scene tree for the first time.
func _ready():
	detect_corners()
	
	if debug:
		debug_show_maze_corners()

func detect_corners():
	var exit_node:ExitZone = get_tree().get_first_node_in_group("Exit")
	var exit_node_waypoint:Node3D = exit_node.get_node("Waypoint")
	var all_mob_ground_tiles = get_tree().get_nodes_in_group("MobGround")
	
	for i in range(all_mob_ground_tiles.size()):
		var current_mob_ground = all_mob_ground_tiles[i]
		# Make sure we don't try to access an index beyond the size of the array
		if i < all_mob_ground_tiles.size() -2:
			var next_mob_ground = all_mob_ground_tiles[i+1]
			var next_next_mob_ground = all_mob_ground_tiles[i+2]
			
			var next_node_direction_normalized = (current_mob_ground.global_transform.origin - next_mob_ground.global_transform.origin).normalized()
			var next_next_node_direction_normalized = (current_mob_ground.global_transform.origin - next_next_mob_ground.global_transform.origin).normalized()
			
			if(next_node_direction_normalized != next_next_node_direction_normalized):
				td_maze_corners.append(next_mob_ground.get_node("Waypoint"))
	
	# Add the exit node
	td_maze_corners.append(exit_node_waypoint)


func debug_show_maze_corners():
	for corner in td_maze_corners:
		var i = debug_mesh.instantiate()
		corner.add_child(i)
		i.transform.origin = Vector3.ZERO
