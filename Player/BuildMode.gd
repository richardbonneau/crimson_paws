extends Node3D

@onready var parent:CharacterBody3D = get_parent()
@onready var turret_build_preview_container:Node3D = $TurretBuildPreview

# TODO: use global list of turrets packedscenes
var arrow_tower_scene:PackedScene = preload("res://Towers/TowerVariants/ArrowTurret.tscn")

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
		towers_container.add_child(tower_to_build)
		tower_to_build.global_transform.origin = build_location
		
		parent.is_in_build_mode = false

func check_if_valid_building_emplacement(event) -> void:
	if parent.is_in_build_mode and event is InputEventMouseMotion:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position, 13)
		# If the ray hits a towerground collider, instantiate a tower preview
		# TODO: I think the raycasts hits collider parts of the instantiated tower. I might need to turn them off when instantiating a preview
		if result:
			var col_in_res = "collider" in result
			var name = result["collider"].name == "TowerGroundCollider"
			print(result["collider"].name)
		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			# TODO: replace dictionary(result) with Node (result[collider])
			display_tower_preview(result)
		# Else turn off the turret preview so that it doesn't stay in the last towerground hit
		else:
#			print("else")
			turret_build_preview_container.visible = false
	elif turret_build_preview_container.visible == true:
#		print("else if")
		turret_build_preview_container.visible = false


func display_tower_preview(result: Dictionary) -> void:
	var build_pos:Vector3 = result["collider"].global_transform.origin
	# TODO: Turrets height are a bit fucky. The Towers Container in main is hovering above the rest but that wouldnt take into account a level with different heights
	build_pos.y += 1
	
	if build_pos != build_location:
		var tower_to_build_instance:Node3D = arrow_tower_scene.instantiate()
		var tower_to_build_visuals:Node3D = tower_to_build_instance.get_node("Visuals").duplicate()
		tower_to_build_instance.queue_free()
		
		turret_build_preview_container.add_child(tower_to_build_visuals)
		tower_to_build_visuals.global_transform.origin = build_pos
		
		build_location = build_pos
	


func instantiate_tower_to_build(build_pos: Vector3) -> Node3D:
	var existing_number_of_preview_towers:int = turret_build_preview_container.get_child_count()
#	print(existing_number_of_preview_towers)
	if existing_number_of_preview_towers > 0:
		var existing_preview_turret:Node3D = turret_build_preview_container.get_child(0)
		existing_preview_turret.queue_free()
	
	var new_tower_to_build:Node3D = CustomFunctions.instantiate_and_append_to_node3d(build_pos, arrow_tower_scene, turret_build_preview_container)
#	print(build_pos)
#	print(new_tower_to_build.global_transform.origin)
#	print("---")
	tower_to_build = new_tower_to_build
	return new_tower_to_build

