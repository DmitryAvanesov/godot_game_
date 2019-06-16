extends TextureButton

func on_btn_click():
	GLOBAL.is_new_game = true
	get_tree().change_scene("res://scenes/act_1/test_2_floor_scene/2Floor.tscn")
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 