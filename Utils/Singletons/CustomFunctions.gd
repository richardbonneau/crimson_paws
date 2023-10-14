extends Node

func create_ray_and_register_hit(click_position:Vector2):
	var camera: Camera3D = get_viewport().get_camera_3d()
	var ray_origin: Vector3 = camera.project_ray_origin(click_position)
	var ray_end: Vector3 = ray_origin + camera.project_ray_normal(click_position) * 1000.0
	var space_state:PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var ray_params:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_params.from = ray_origin
	ray_params.to = ray_end
	var result:Dictionary = space_state.intersect_ray(ray_params)
	
	return result
