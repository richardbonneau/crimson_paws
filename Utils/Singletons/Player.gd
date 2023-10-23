extends Node

signal set_lives_signal
signal game_over_signal

var lives:int = 2

func remove_lives(lives_to_remove:int):
	lives = lives - lives_to_remove
	if lives < 1:
		#GAMEOVER
		print("GAMEOVER")
		emit_signal("game_over_signal")
	else:
		#Signal UI to display new lives
		emit_signal("set_lives_signal", lives)
	
