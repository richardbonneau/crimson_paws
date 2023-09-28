extends CharacterBody3D

@export var target_reached_offset_threshold:float = 1
@export var buffer_distance_once_waypoint_reached:float = target_reached_offset_threshold + 1
var has_waypoint_been_just_reached:bool = false

var start_node:Area3D
var exit_node:Area3D

var _waypoint_index = 0
var _waypoints = []

var movement_speed: float = 7
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

func _ready():
	#	Get the corners array
	start_node = get_tree().get_nodes_in_group("Start")[0]
	_waypoints = start_node.td_maze_corners
	#	Find the Exit Node
	exit_node = get_tree().get_nodes_in_group("Exit")[0]
	_waypoints.append(exit_node)
	
	# These values need to be adjusted for the actor's speed
	# and the navigation layout.
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5

	# Make sure to not await during _ready.
	call_deferred("actor_setup")

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	go_to_next_waypoint()

func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)

func go_to_next_waypoint():
	var movement_target_position:Vector3
	
	if _waypoints.size() > 0:
		movement_target_position = _waypoints[_waypoint_index].global_transform.origin
	
	set_movement_target(movement_target_position)

func is_target_in_range(target_node,threshold):
	var distance = $WaypointFinder.global_transform.origin.distance_to(target_node.global_transform.origin)
	return distance < threshold

func is_waypoint_reached():
	var current_waypoint = _waypoints[_waypoint_index]
	return is_target_in_range(current_waypoint,target_reached_offset_threshold)

func is_out_of_last_waypoint_range():
	var last_waypoint = _waypoints[_waypoint_index - 1]
	return is_target_in_range(last_waypoint,buffer_distance_once_waypoint_reached)

func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	if is_waypoint_reached() and has_waypoint_been_just_reached == false:
		# Make sure we don't crash if we increment the index and run go_to_next_waypoint
		if _waypoint_index + 1 > _waypoints.size() -1:
			return
		
		has_waypoint_been_just_reached = true
		_waypoint_index += 1
		go_to_next_waypoint()
		
	
	if is_out_of_last_waypoint_range() and has_waypoint_been_just_reached != false:
		has_waypoint_been_just_reached = false
	
	
	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	
	var new_velocity: Vector3 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed

	velocity = new_velocity
	move_and_slide()
