extends Camera3D

@export var player_to_follow:CharacterBody3D

func _process(delta: float) -> void:
	self.transform.origin.x = player_to_follow.transform.origin.x
	self.transform.origin.z = player_to_follow.transform.origin.z
