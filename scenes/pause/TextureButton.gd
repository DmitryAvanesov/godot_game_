extends TextureButton

func on_btn_click():
	var new_pause_state = not get_tree().paused
	get_tree().paused = new_pause_state
	get_parent().get_parent().get_parent().get_parent().visible = new_pause_state
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 