extends Node

func create_ray_and_register_hit(click_position:Vector2) -> Dictionary:
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

func append_instance_to_node3d(instance_position:Vector3, instance: Node3D, parent_of_instance: Node = get_tree().root) -> Node3D:
	parent_of_instance.add_child(instance)
	instance.global_transform.origin = instance_position
	return instance

func change_node_visibility(node3d:Node3D, is_visible: bool):
	if node3d.visible == !is_visible:
		node3d.visible = is_visible

func load_resources_from_folder(path: String)->Array:
	var resources_to_return:Array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name: String = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				var resource = load(path + file_name)
				if resource:
					resources_to_return.append(resource)
			file_name = dir.get_next()
		return resources_to_return
	else:
		push_warning("Failed to open directory:", path)
		return resources_to_return
