extends Node3D

@onready var parent:CharacterBody3D = get_parent()
@onready var turret_build_preview_container:Node3D = $TurretBuildPreview

# TODO: use global list of turrets packedscenes
var basic_tower_scene:PackedScene = preload("res://Towers/TowerCore/TowerCore.tscn")

var build_location:Vector3
var tower_to_build:Node3D

func _input(event) -> void:
	check_if_valid_building_emplacement(event)
	build_tower(event)

func build_tower(event) -> void:
	if parent.is_in_build_mode and build_location and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var tower:Node3D = instantiate_tower_to_build(build_location)
		var towers_container = get_tree().get_nodes_in_group("TowersContainer")[0]
		
		# TODO: tower doesn't seem to build
		print(tower_to_build)
		tower_to_build.global_transform.origin = build_location
		towers_container.add_child(tower_to_build)
		
		parent.is_in_build_mode = false

func check_if_valid_building_emplacement(event) -> void:
	if parent.is_in_build_mode and event is InputEventMouseMotion:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position)
		# If the ray hits a towerground collider, instantiate a tower preview
		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			display_tower_preview(result)
		# Else turn off the turret preview so that it doesn't stay in the last towerground hit
		else:
			turret_build_preview_container.visible = false
	elif turret_build_preview_container.visible == true:
		turret_build_preview_container.visible = false


func display_tower_preview(result: Dictionary) -> void:
	var build_pos:Vector3 = result["collider"].global_transform.origin
	build_pos.y += 1
	
	instantiate_tower_to_build(build_pos)
	turret_build_preview_container.visible = true
	turret_build_preview_container.global_transform.origin = build_pos
	build_location = build_pos
	


func instantiate_tower_to_build(build_pos: Vector3) -> Node3D:
	var new_tower_to_build:Node3D = basic_tower_scene.instantiate()
	var existing_number_of_preview_towers:int = turret_build_preview_container.get_child_count()
	print(existing_number_of_preview_towers)
	if existing_number_of_preview_towers > 0:
		var existing_preview_turret:Node3D = turret_build_preview_container.get_child(0)
		existing_preview_turret.queue_free()
	# TODO: This happens on every tick. BAD!
	CustomFunctions.instantiate_and_append_to_node3d(build_pos, new_tower_to_build, turret_build_preview_container)
	
	tower_to_build = new_tower_to_build
	return new_tower_to_build

