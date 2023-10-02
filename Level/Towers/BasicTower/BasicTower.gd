@tool
extends Node3D

var is_detection_visualizer_visible:bool = false :
	set(value):
		is_detection_visualizer_visible = value
		$Detection/DetectionVisualizer.visible = value

@export var detection_radius: float = 5.0 :
	set(value):
		detection_radius = value
		set_detection_radius(value)

func _ready():
	set_detection_radius(detection_radius) 

func set_detection_radius(detection_radius):
	# Adjust the collision shape
	$Detection/DetectionArea.scale = Vector3(detection_radius, detection_radius, detection_radius)
	# Adjust the visual representation
	$Detection/DetectionVisualizer.scale = Vector3(detection_radius, 0.1, detection_radius)
