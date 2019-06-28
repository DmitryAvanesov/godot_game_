extends CanvasLayer


func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	$Control.visible = true