class_name BasicEnemy
extends CharacterBody3D

@export var movement_speed:float = 5
@export var rotation_speed:float = 15
@export var debug:bool = false

@onready var health:Node3D = $Health



