class_name EnemyCore
extends CharacterBody3D

var movement_speed:float = 5
var rotation_speed:float = 8
@export var debug:bool = false

@onready var health:Node3D = $Health
@onready var navigation:Node3D = $Navigation

func set_stats(enemy_data:EnemyData):
	self.movement_speed = enemy_data.movement_speed
	self.rotation_speed = enemy_data.rotation_speed
	
	health.set_max_health(enemy_data.health)


