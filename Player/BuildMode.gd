extends Node3D

@onready var parent:CharacterBody3D = get_parent()

var basic_tower_scene:PackedScene = preload("res://Towers/TowerCore/TowerCore.tscn")

var build_location:Vector3

func _input(event):
	place_building_blueprint(event)
	build_tower(event)

func build_tower(event):
#	print(parent.is_in_build_mode)
#	print(build_location)
#	print(event is InputEventMouseButton)
#	print(event.button_index == MOUSE_BUTTON_RIGHT)
	if parent.is_in_build_mode and build_location and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("miaow")
		var tower:Node3D = basic_tower_scene.instantiate()
		var towers_container = get_tree().get_nodes_in_group("TowersContainer")[0]
		towers_container.add_child(tower)
		tower.global_transform.origin = build_location
		parent.is_in_build_mode = false

func place_building_blueprint(event):
	if parent.is_in_build_mode and event is InputEventMouseMotion:
		var camera: Camera3D = get_viewport().get_camera_3d()
		var ray_origin: Vector3 = camera.project_ray_origin(event.position)
		var ray_end: Vector3 = ray_origin + camera.project_ray_normal(event.position) * 1000.0
		var space_state:PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
		var ray_params:PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.new()
		ray_params.from = ray_origin
		ray_params.to = ray_end
		var result = space_state.intersect_ray(ray_params)

		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			var build_pos:Vector3 = result["collider"].global_transform.origin
			build_pos.y += 1
			$MeshInstance3D.visible = true
			$MeshInstance3D.global_transform.origin = build_pos
			build_location = build_pos
		else:
			$MeshInstance3D.visible = false
	else:
		$MeshInstance3D.visible = false

