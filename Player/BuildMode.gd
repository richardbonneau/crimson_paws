extends Node3D

@onready var parent:CharacterBody3D = get_parent()
@onready var turret_build_preview:Node3D = $TurretBuildPreview

# TODO: use global list of turrets packedscenes
var basic_tower_scene:PackedScene = preload("res://Towers/TowerCore/TowerCore.tscn")

var build_location:Vector3
var tower_to_build:Node3D

func _input(event):
	place_building_blueprint(event)
	build_tower(event)


func build_tower(event):
	if parent.is_in_build_mode and build_location and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var tower:Node3D = basic_tower_scene.instantiate()
		var towers_container = get_tree().get_nodes_in_group("TowersContainer")[0]
		towers_container.add_child(tower)
		tower.global_transform.origin = build_location
		parent.is_in_build_mode = false

func place_building_blueprint(event):
	if parent.is_in_build_mode and event is InputEventMouseMotion:
		var result:Dictionary = CustomFunctions.create_ray_and_register_hit(event.position)
		# If the ray hits a towerground collider, instantiate a tower preview
		if result and "collider" in result and result["collider"].name == "TowerGroundCollider":
			var build_pos:Vector3 = result["collider"].global_transform.origin
			build_pos.y += 1
			turret_build_preview.visible = true
			turret_build_preview.global_transform.origin = build_pos
			build_location = build_pos
		# Else turn off the turret preview so that it doesn't stay in the last towerground hit
		else:
			turret_build_preview.visible = false
	else:
		turret_build_preview.visible = false

