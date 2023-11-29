extends Node3D

signal is_building_mode_signal

@onready var parent:Node3D = get_parent()

func building_mode():
	emit_signal("is_building_mode_signal")
