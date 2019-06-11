extends TextureButton

func on_btn_click():
	print('dsd')
	get_tree().quit()
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 