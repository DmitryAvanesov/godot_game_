extends TextureButton

func on_btn_click():
	GLOBAL.is_new_game = true
	get_tree().change_scene('res://scenes/act_1/preparation_scene/Preparation_scene.tscn')
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 