extends CanvasLayer

func _ready():
	if GLOBAL.is_new_game:
		$Start_text.visible = false
	else:
		yield(get_tree().create_timer(2.0), "timeout")
		$Start_text.visible = false