extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var health:Node3D = get_node("../Health")
	health.connect("death_signal", on_death)

func on_death():
	self.visible = false
