extends Sprite3D

@onready var progress_bar:TextureProgressBar = $SubViewport/TextureProgressBar

func set_max_value(max_value:float):
	progress_bar.max_value = max_value

func set_value(value:float):
	progress_bar.value = value
