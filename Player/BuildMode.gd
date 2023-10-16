extends Node3D

# TODO: use global list of turrets packedscenes
var arrow_tower_scene:PackedScene = preload("res://Towers/TowerVariants/ArrowTurret/ArrowTurret.tscn")

var arrow_tower_visuals_scene:PackedScene = preload("res://Towers/TowerVariants/ArrowTurret/Visuals/ArrowTurretVisuals.tscn")
var tower_preview:Node3D

var build_location:Vector3 = Vector3.INF

@onready var parent:CharacterBody3D = get_parent()
@onready var towers_container:Node3D = get_tree().get_nodes_in_group("TowersContainer")[0]


func _input(event) -> void:
	if parent.is_in_build_mode:
		print(build_location)
		check_if_valid_building_emplacement(event)
		build_tower(event)

func check_if_valid_building_emplacement(event) -> void:
	if event is InputEventMouseMotion:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position, 13)
		# If the ray hits a towerground collider, instantiate a tower preview
		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			# TODO: replace dictionary(result) with Node (result[collider])
			display_tower_preview(result["collider"])
		# We are no longer targeting a TowerGroundCollider
		elif tower_preview:
			if build_location != Vector3.INF:
				build_location = Vector3.INF
			CustomFunctions.change_node_visibility(tower_preview, false)
	elif tower_preview and tower_preview.visible == true:
		CustomFunctions.change_node_visibility(tower_preview, false)

func display_tower_preview(tower_ground: Node3D) -> void:
	var build_pos:Vector3 = tower_ground.global_transform.origin
	# TODO: Turrets height are a bit fucky. The Towers Container in main is hovering above the rest but that wouldnt take into account a level with different heights
	build_pos.y += 1.5

	if build_pos != build_location:
		if tower_preview == null:
			tower_preview = CustomFunctions.instantiate_and_append_to_node3d(build_pos, arrow_tower_visuals_scene)
		else:
			CustomFunctions.change_node_visibility(tower_preview, true)
			tower_preview.global_transform.origin = build_pos
		build_location = build_pos


func build_tower(event) -> void:
	if build_location != Vector3.INF and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("CLICK")
		# Instantiate and create tower
		CustomFunctions.instantiate_and_append_to_node3d(build_location, arrow_tower_scene,towers_container)
		# Delete Tower Preview
		tower_preview.queue_free()
		tower_preview = null
		# Clear all vars and exit build mode
		parent.is_in_build_mode = false
		build_location = Vector3.INF



