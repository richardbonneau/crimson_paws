@tool
extends Node3D

@export var is_detection_visualizer_visible:bool = false :
	set(value):
		is_detection_visualizer_visible = value
		$Shooting/Detection/DetectionVisualizer.visible = value

@export var detection_radius: float = 5.0 :
	set(value):
		detection_radius = value
		set_detection_radius(value)

func _ready():
	set_detection_radius(detection_radius) 

func set_detection_radius(detection_radius):
	# Adjust the collision shape
	$Shooting/Detection/DetectionArea.scale = Vector3(detection_radius, detection_radius, detection_radius)
	# Adjust the visual representation
	$Shooting/Detection/DetectionVisualizer.scale = Vector3(detection_radius, 0.1, detection_radius)
