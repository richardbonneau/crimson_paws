extends CharacterBody3D

@export var movement_speed: float = 3.0
@export var rotation_speed: float = 8.0

@export var dive_angle_speed: float = 1.0
@export var zoom_speed: float = 0.1
@export var max_zoom_deg:float = -60
@export var min_zoom_deg: float = -40

var target_position: Vector3 = Vector3.ZERO
var moving: bool = false

var is_in_build_mode = false

@onready var third_person_camera:ThirdPersonCamera = $ThirdPersonCamera
@onready var navigation_agent:NavigationAgent3D = $NavigationAgent3D

func _ready():
	$"mannequiny-0_4_0/AnimationPlayer".play("idle")

func _input(event: InputEvent) -> void:
	player_movement(event)
	camera_zoom(event)

func player_movement(event: InputEvent) ->void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position)
		
		if result:
			target_position = result.position
			moving = true
			navigation_agent.set_target_position(target_position)

func camera_zoom(event:InputEvent):
	if event is InputEventMouseButton:
		var new_dive_angle:float = third_person_camera.initial_dive_angle_deg
		var new_distance_from_pivot:float = third_person_camera.distance_from_pivot
		if event.is_action_pressed("zoom_in"):
			new_dive_angle += dive_angle_speed
			new_distance_from_pivot -= zoom_speed
		elif event.is_action_pressed("zoom_out"):
			new_dive_angle -= dive_angle_speed
			new_distance_from_pivot += zoom_speed
		
		if new_dive_angle < min_zoom_deg and new_dive_angle > max_zoom_deg:
			third_person_camera.initial_dive_angle_deg = new_dive_angle
			third_person_camera.distance_from_pivot = new_distance_from_pivot

func _physics_process(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		$"mannequiny-0_4_0/AnimationPlayer".play("idle")
		return
	
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = next_path_position - global_transform.origin
	if direction.length() > 0.1:
		direction.y = 0
		direction = direction.normalized()
		self.velocity = direction * movement_speed
	
		var look_target = Vector3(next_path_position.x, self.global_transform.origin.y, next_path_position.z)
		var target_rotation = self.global_transform.looking_at(look_target, Vector3.UP).basis
		self.global_transform.basis = self.global_transform.basis.slerp(target_rotation, self.rotation_speed * delta)
		$"mannequiny-0_4_0/AnimationPlayer".play("walk")
		print(direction.length())
		move_and_slide()
		
