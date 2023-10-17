extends Node

func create_ray_and_register_hit(click_position:Vector2, collision_layer: int = -1) -> Dictionary:
	var camera: Camera3D = get_viewport().get_camera_3d()
	var ray_origin: Vector3 = camera.project_ray_origin(click_position)
	var ray_end: Vector3 = ray_origin + camera.project_ray_normal(click_position) * 1000.0
	var space_state:PhysicsDirectSpaceState3D = get_viewport().get_world_3d().direct_space_state
	var ray_params:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
	ray_params.from = ray_origin
	ray_params.to = ray_end
	# if no collision layer is provided, hit all layers
	var result:Dictionary = space_state.intersect_ray(ray_params)
	return result

func instantiate_and_append_to_node3d(new_node3d_position:Vector3, new_node3d: PackedScene, parent_of_new_node3d: Node = get_tree().root) -> Node3D:
	var new_node3d_instance:Node3D = new_node3d.instantiate()
	parent_of_new_node3d.add_child(new_node3d_instance)
	new_node3d_instance.global_transform.origin = new_node3d_position
	return new_node3d_instance

func change_node_visibility(node3d:Node3D, is_visible: bool):
	if node3d.visible == !is_visible:
		node3d.visible = is_visible
