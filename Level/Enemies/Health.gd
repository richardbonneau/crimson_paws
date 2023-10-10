extends Node

@onready var scene_root:CharacterBody3D = get_parent()
@onready var health_bar:Sprite3D = $ProgressBar3D

var max_health:int = 5
var current_health:int = max_health
var is_alive:bool = true

func _ready():
	set_max_health(max_health)

func set_max_health(new_max_health:int):
	health_bar.set_max_value(new_max_health)

func take_damage(incoming_damage:int):
	current_health = current_health - incoming_damage
	health_bar.set_value(current_health)
	if current_health < 1:
		death()

func death():
	# Remove the collisionshape so that it doesn't appear in the target lists of towers
	scene_root.get_node("CollisionShape3D").queue_free()
	
	scene_root.get_node("serpent").visible = false
	scene_root.get_node("DeathParticles").restart()
	$DeathTimer.start()

func _on_death_timer_timeout():
	scene_root.queue_free()
