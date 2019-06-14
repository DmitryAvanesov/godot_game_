extends TextureButton

func on_btn_click():
	get_tree().change_scene("res://scenes/act_1/town/Town.tscn")
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 