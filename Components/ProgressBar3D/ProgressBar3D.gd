extends Sprite3D

@onready var progress_bar:TextureProgressBar = $SubViewport/TextureProgressBar

func _ready():
	print("ready hello")
#	var viewport_texture:ViewportTexture = ViewportTexture.new()
#	var subviewport_path:NodePath = NodePath("SubViewport")
#	print(subviewport_path)
#	viewport_texture.set_viewport_path_in_scene(subviewport_path)
#	set_texture(viewport_texture)
#	print(viewport_texture)

func set_max_value(max_value:float):
	progress_bar.max_value = max_value

func set_value(value:float):
	progress_bar.value = value
