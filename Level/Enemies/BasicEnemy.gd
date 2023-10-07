extends CharacterBody3D

# Health
var max_health:int = 5
var current_health:int = max_health
var is_alive:bool = true

func take_damage(incoming_damage:int):
	current_health = current_health - incoming_damage
	if current_health < 0:
		death()

func death():
	$serpent.visible = false
	$DeathParticles.restart()
	$Health/DeathTimer.start()


