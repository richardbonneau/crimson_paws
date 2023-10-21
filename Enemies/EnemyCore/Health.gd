extends Node

signal death_signal

@onready var scene_root:CharacterBody3D = get_parent()
@onready var health_bar:Sprite3D = $HealthBar

var max_health:int = 5
var current_health:int = max_health
var is_alive:bool = true

func _ready():
	set_max_health(max_health)
	health_bar.substract_delay = true

func set_max_health(new_max_health:int):
	max_health = new_max_health
	current_health = new_max_health
	health_bar.set_max_value(new_max_health)

func take_damage(incoming_damage:int):
	current_health = current_health - incoming_damage
	health_bar.set_value(current_health)
	if current_health < 1:
		death()

func death():
	# Remove the collisionshape so that it doesn't appear in the target lists of towers
	scene_root.get_node("CollisionShape3D").queue_free()
	health_bar.queue_free()
	# To be used by EnemyVariant
	emit_signal("death_signal")
	
	$DeathParticles.restart()
	$DeathTimer.start()

func _on_death_timer_timeout():
	scene_root.queue_free()
