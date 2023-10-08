extends Label3D

@onready var camera:Camera3D = get_tree().get_nodes_in_group("Camera")[0]

func _process(_delta: float) -> void:
	var behind_cam = global_transform.origin - camera.global_transform.origin
	var camera_pos = global_transform.origin + behind_cam
	
	camera_pos.y = global_transform.origin.y
	look_at(camera_pos, Vector3.UP)
