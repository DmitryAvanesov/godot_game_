extends TextureButton

func on_btn_click():
	get_tree().change_scene("res://scenes/act_1/location_1_test/Loc1Scene.tscn")
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 