class_name EnemyCore
extends CharacterBody3D

@export var movement_speed:float = 5
@export var rotation_speed:float = 8
@export var debug:bool = false

@onready var health:Node3D = $Health
@onready var navigation:Node3D = $Navigation



