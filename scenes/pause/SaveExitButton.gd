extends TextureButton
func save_game():
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json({'location':GLOBAL.last_scene, \
	'have_been_in_house':GLOBAL.haveBeenInHouse}))
	var save_nodes = get_tree().get_nodes_in_group("People")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	
	save_game.close()
	
func on_btn_click():
	save_game()
	get_tree().quit()
	get_tree().change_scene("res://scenes/menu/Menu.tscn")
	pass
	
func _ready():
	connect("pressed", self, 'on_btn_click')
	pass 