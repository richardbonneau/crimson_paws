extends Control

@onready var lives_number_label:Label = $HBoxContainer/LivesNumber

func _ready()->void:
	Player.connect("set_lives_signal",on_set_lives)
	lives_number_label.set_text(str(Player.lives))


func on_set_lives(new_lives:int):
	print("new_lives",new_lives)
