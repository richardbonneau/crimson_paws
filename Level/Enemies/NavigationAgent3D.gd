class_name EnemyNav
extends NavigationAgent3D

@onready var parent:CharacterBody3D = self.get_parent()
@onready var waypointFinder:Node3D = parent.get_node("WaypointFinder")

@onready var movement_speed: float = parent.movement_speed
@onready var debug: bool = parent.debug

var target_reached_offset_threshold:float = 1
var buffer_distance_once_waypoint_reached:float = target_reached_offset_threshold + 1
var has_waypoint_been_just_reached:bool = false

var start_node:Area3D
var exit_node:Area3D

var _waypoints = []
var waypoint_index = 0
var distance_to_next_waypoint:float = 0

func _ready():
	#	Get the corners array
	start_node = get_tree().get_nodes_in_group("Start")[0]
	_waypoints = start_node.td_maze_corners
	#	Find the Exit Node
	exit_node = get_tree().get_nodes_in_group("Exit")[0]
	_waypoints.append(exit_node)
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	self.path_desired_distance = 0.5
	self.target_desired_distance = 0.5
	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	# Now that the navigation map is no longer empty, set the movement target.
	go_to_next_waypoint()

func set_movement_target(movement_target: Vector3):
	self.set_target_position(movement_target)

func go_to_next_waypoint():
	var movement_target_position:Vector3
	if _waypoints.size() > 0:
		movement_target_position = _waypoints[waypoint_index].global_transform.origin
	set_movement_target(movement_target_position)

func is_target_in_range(target_node,threshold):
	var distance = waypointFinder.global_transform.origin.distance_to(target_node.global_transform.origin)
	distance_to_next_waypoint = distance
	return distance < threshold

func is_waypoint_reached():
	var current_waypoint = _waypoints[waypoint_index]
	return is_target_in_range(current_waypoint, target_reached_offset_threshold)

func is_out_of_last_waypoint_range():
	var last_waypoint = _waypoints[waypoint_index - 1]
	return is_target_in_range(last_waypoint, buffer_distance_once_waypoint_reached)

func _physics_process(_delta:float)-> void:
	if self.is_navigation_finished():
		return
	
	if has_waypoint_been_just_reached == false and is_waypoint_reached():
		# Make sure we don't crash if we increment the index and run go_to_next_waypoint
		if waypoint_index + 1 > _waypoints.size() -1:
			return
		
		has_waypoint_been_just_reached = true
		waypoint_index += 1
		go_to_next_waypoint()
	
	if has_waypoint_been_just_reached != false and is_out_of_last_waypoint_range():
		has_waypoint_been_just_reached = false
	
	var current_agent_position: Vector3 = parent.global_position
	var next_path_position: Vector3 = self.get_next_path_position()
	
	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	
	parent.velocity = new_velocity
	var look_target = Vector3(_waypoints[waypoint_index].global_transform.origin.x, parent.global_transform.origin.y, _waypoints[waypoint_index].global_transform.origin.z)
	parent.look_at(look_target, Vector3.UP)
	
	parent.move_and_slide()

