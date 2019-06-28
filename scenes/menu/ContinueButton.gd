extends TextureButton


func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		
		
		
		GLOBAL.is_new_game = false
		var save_game = File.new()
		save_game.open("user://savegame.save", File.READ)
		var json = parse_json(save_game.get_line())
		GLOBAL.last_scene = json['location']
		GLOBAL.haveBeenInHouse = json['have_been_in_house']
		GLOBAL.have_been_in_camp = json['have_been_in_camp']
		GLOBAL.dialog_counter = json['dialog_counter']
		$Loading.get_child(0).visible = true
		yield(get_tree().create_timer(1.0), "timeout")
		get_tree().change_scene(GLOBAL.last_scene)