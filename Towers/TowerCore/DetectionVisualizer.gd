extends MeshInstance3D

func set_radius(radius:float):
	self.scale = Vector3(radius, 0.1, radius)
