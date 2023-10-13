extends MeshInstance3D

@onready var parent:Node3D = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("../BuildingBlueprint").connect("is_building_mode_signal",building_mode)


func building_mode():
	var material: StandardMaterial3D = get_active_material(0)
	material.albedo_color.a = 0.2
