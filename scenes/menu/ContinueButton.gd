extends TextureButton

func on_btn_click():
	print(1)
	get_tree().change_scene("res://scenes/act_1/test_2_floor_scene/2Floor.tscn")
	pass
	
func _ready():
	print(2)
	connect("pressed", self, 'on_btn_click')
	pass 