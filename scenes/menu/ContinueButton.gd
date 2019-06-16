extends TextureButton


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		get_tree().change_scene("res://scenes/act_1/test_2_floor_scene/2Floor.tscn")