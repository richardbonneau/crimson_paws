@tool
extends Node3D

@onready var shooting:Node3D = $Shooting

var is_building_blueprint:bool = false :
	set(value):
		is_building_blueprint = value
		$BuildingBlueprint.building_mode()

@export var is_detection_visualizer_visible:bool = false :
	set(value):
		is_detection_visualizer_visible = value
		# TODO: Crashes on load otherwise. Is there a better way to prevent the crash?
		if has_node("Shooting/Detection/DetectionVisualizer"):
			$Shooting/Detection/DetectionVisualizer.visible = value

@export var detection_radius: float = 5.0 :
	set(value):
		detection_radius = value
		set_detection_radius()

func _ready():
	set_detection_radius() 

func set_detection_radius():
	# Adjust the collision shape
	$Shooting/Detection/DetectionArea.scale = Vector3(detection_radius, detection_radius, detection_radius)
	# Adjust the visual representation
	var detection_visualizer:DetectionVisualizer = $Shooting/Detection/DetectionVisualizer
	detection_visualizer.set_radius(detection_radius)

func set_stats(tower_data:TowerData):
	self.detection_radius = tower_data.radius
	shooting.set_attack_speed(tower_data.attack_speed)
	shooting.set_damage(tower_data.damage)
