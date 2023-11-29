extends Sprite3D

@onready var progress_bar:TextureProgressBar = $SubViewport/Control/GreenBar
@onready var preview_bar:TextureProgressBar = $SubViewport/Control/YellowBar
@onready var delay_timer:Timer = $ProgressChangeDelay

var substract_delay:bool = false
var value_to_catch_up_to:float = 0
var is_interpolating:bool = false
@export var damage_lag_lerp_speed:float = 0.01

func set_max_value(max_value:float):
	progress_bar.max_value = max_value
	progress_bar.value = max_value
	preview_bar.max_value = max_value
	preview_bar.value = max_value

func set_value(value:float):
	if substract_delay:
		progress_bar.value = value
		value_to_catch_up_to = value
		
		delay_timer.stop()
		delay_timer.start()
	else:
		progress_bar.value = value
		preview_bar.value = value

func _on_progress_change_delay_timeout():
	is_interpolating = true
	

func _physics_process(_delta):
	if is_interpolating:
		preview_bar.value = preview_bar.value - damage_lag_lerp_speed
		if abs(preview_bar.value - progress_bar.value) < 0.01:
			preview_bar.value = progress_bar.value
			is_interpolating = false
			delay_timer.stop()
			