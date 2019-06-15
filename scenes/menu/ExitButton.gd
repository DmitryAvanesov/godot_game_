extends TextureButton

func on_btn_click():
	get_tree().quit()
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 