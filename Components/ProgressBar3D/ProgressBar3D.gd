extends Node3D

# Also sets initial progress
@export var current_progress:float = 1

func _ready():
	set_progress_bar(0.333333333333333333333)

func set_progress_bar(new_value:float):
	var new_scale = new_value * 3
	$Progress.scale.x = new_scale

