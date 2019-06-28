extends Node2D

func load_game():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return
	save_game.open("user://savegame.save", File.READ)
	var current_line = parse_json(save_game.get_line())
	var save_nodes = get_tree().get_nodes_in_group("People")
	for i in save_nodes:
		current_line = parse_json(save_game.get_line())
		i.call('load_from_dict', current_line)
	save_game.close()

func _ready():
	if not GLOBAL.is_new_game:
		GLOBAL.is_new_game = false
		load_game()