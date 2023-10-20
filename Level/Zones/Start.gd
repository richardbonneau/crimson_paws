extends Area3D

var debug_mesh:PackedScene = preload("res://Utils/Debug/DebugMesh.tscn")

@export var td_maze_corners = []

# Called when the node enters the scene tree for the first time.
func _ready():
	detect_corners()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta:float):
	pass

func detect_corners():
	var exit_node:Node3D = get_tree().get_first_node_in_group("Exit")
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
	td_maze_corners.append(exit_node)

