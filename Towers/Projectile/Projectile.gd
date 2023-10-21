extends RigidBody3D

@export var expiration_time:float = 10.0

var damage:int = 2
var speed:float = 30.0
var _target:Node3D

func _start():
	$Timer.set_wait_time(expiration_time)
	$Timer.start()

func _physics_process(_delta:float):
	if _target and is_instance_valid(_target):
		var direction = (_target.global_transform.origin - global_transform.origin).normalized()
		linear_velocity = direction * speed
	else:
		self.queue_free()

func seek_and_destroy_target(target: Node3D, new_damage:int):
	damage = new_damage
	_target = target

func _on_body_entered(body):
	if body == _target:
		body.health.take_damage(damage)
		self.queue_free()


func _on_timer_timeout() -> void:
	self.queue_free()
