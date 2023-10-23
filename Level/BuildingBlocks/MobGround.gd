@tool
extends Node3D

@export var is_curved:bool = false:
	set(new_is_curved):
		is_curved = new_is_curved
		$CurvedPath.visible = new_is_curved
		$StraightPath.visible = !new_is_curved
	


