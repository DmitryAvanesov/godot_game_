extends TextureButton

func on_btn_click():
	GLOBAL.is_new_game = true
	$Loading.get_child(0).visible = true
	yield(get_tree().create_timer(1.0), "timeout")
	get_tree().change_scene('res://scenes/act_1/preparation_scene/Preparation_scene.tscn')
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 