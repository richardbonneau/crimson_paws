extends Node3D

@onready var parent:CharacterBody3D = get_parent()

# TODO: use global list of turrets packedscenes
var arrow_tower_scene:PackedScene = preload("res://Towers/TowerVariants/ArrowTurret/ArrowTurret.tscn")

var arrow_tower_visuals_scene:PackedScene = preload("res://Towers/TowerVariants/ArrowTurret/Visuals/ArrowTurretVisuals.tscn")
var tower_preview:Node3D

var build_location:Vector3


func _input(event) -> void:
	check_if_valid_building_emplacement(event)
#	build_tower(event)

func check_if_valid_building_emplacement(event) -> void:
	if parent.is_in_build_mode and event is InputEventMouseMotion:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position, 13)
		# If the ray hits a towerground collider, instantiate a tower preview
		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			# TODO: replace dictionary(result) with Node (result[collider])
			display_tower_preview(result)
		# We are no longer targeting a TowerGroundCollider
		elif tower_preview:
			if build_location != Vector3.ZERO:
				build_location = Vector3.ZERO
			CustomFunctions.change_node_visibility(tower_preview, false)
	elif tower_preview and tower_preview.visible == true:
		print("2")
		CustomFunctions.change_node_visibility(tower_preview, false)

func display_tower_preview(result: Dictionary) -> void:
	var build_pos:Vector3 = result["collider"].global_transform.origin
	# TODO: Turrets height are a bit fucky. The Towers Container in main is hovering above the rest but that wouldnt take into account a level with different heights
	build_pos.y += 1.5
	print(build_pos,build_location)
	if build_pos != build_location:
		print("build pos build loc")
		if tower_preview == null:
			print("Instantiate and place")
			tower_preview = CustomFunctions.instantiate_and_append_to_node3d(build_pos, arrow_tower_visuals_scene)
		else:
			print("place existing tower visual")
			CustomFunctions.change_node_visibility(tower_preview, true)
			tower_preview.global_transform.origin = build_pos
		build_location = build_pos


#func build_tower(event) -> void:
#	if parent.is_in_build_mode and build_location and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
#		var tower:Node3D = instantiate_tower_to_build(build_location)
#		var towers_container = get_tree().get_nodes_in_group("TowersContainer")[0]
#
#		# TODO: tower doesn't seem to build
#		towers_container.add_child(tower_to_build)
#		tower_to_build.global_transform.origin = build_location
#
#		parent.is_in_build_mode = false





#func instantiate_tower_to_build(build_pos: Vector3) -> Node3D:
#	var existing_number_of_preview_towers:int = turret_build_preview_container.get_child_count()
##	print(existing_number_of_preview_towers)
#	if existing_number_of_preview_towers > 0:
#		var existing_preview_turret:Node3D = turret_build_preview_container.get_child(0)
#		existing_preview_turret.queue_free()
#
#	var new_tower_to_build:Node3D = CustomFunctions.instantiate_and_append_to_node3d(build_pos, arrow_tower_scene, turret_build_preview_container)
##	print(build_pos)
##	print(new_tower_to_build.global_transform.origin)
##	print("---")
#	tower_to_build = new_tower_to_build
#	return new_tower_to_build

