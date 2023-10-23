extends MeshInstance3D
class_name DetectionVisualizer

func set_radius(radius:float):
	self.scale = Vector3(radius, 0.1, radius)
