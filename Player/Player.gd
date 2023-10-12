extends CharacterBody3D

@export var movement_speed: float = 5.0
var target_position: Vector3 = Vector3.ZERO
var moving: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var camera: Camera3D = get_viewport().get_camera_3d()
		var ray_origin: Vector3= camera.project_ray_origin(event.position)
		var ray_end: Vector3 = ray_origin + camera.project_ray_normal(event.position) * 1000.0
		
		var space_state:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var ray_params:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
		ray_params.from = ray_origin
		ray_params.to = ray_end
		var result = space_state.intersect_ray(ray_params)
		
		if result:
			target_position = result.position
			print(target_position)
			moving = true

func _physics_process(delta: float) -> void:
	if moving:
		var direction: Vector3 = target_position - global_transform.origin
		if direction.length() > 0.1:
			direction.y = 0
			direction = direction.normalized()
			self.velocity = direction * movement_speed
			
			
		else:
			self.velocity = Vector3.ZERO
			moving = false
	move_and_slide()
