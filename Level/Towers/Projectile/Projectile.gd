extends RigidBody3D

var speed:float = 30.0
var _target:Node3D

func _physics_process(delta):
	if _target:
		var direction = (_target.global_transform.origin - global_transform.origin).normalized()
		linear_velocity = direction * speed

func set_target_and_shoot(target: Node3D):
	_target = target

func _on_body_entered(body):
	if body == _target:
		body.death()
		self.queue_free()
