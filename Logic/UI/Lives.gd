extends Control

@onready var lives_number_label:Label = $HBoxContainer/LivesNumber

func _ready()->void:
	Player.connect("set_lives_signal",on_set_lives)
	on_set_lives(Player.lives)
	


func on_set_lives(new_lives:int):
	lives_number_label.set_text(str(new_lives))
