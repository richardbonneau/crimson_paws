extends Node

@onready var parent:CharacterBody3D = self.get_parent()
@onready var navigationAgent3D:NavigationAgent3D = parent.get_node("NavigationAgent3D")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	print(navigationAgent3D)
	
