extends Sprite

func tent_on(body):
	if body.is_in_group("gg"):
		visible = true
		
func tent_off(body):
	if body.is_in_group("gg"):
		visible = false
		
func _ready():
	$Area2D.connect("body_entered", self, "tent_on")
	$Area2D2.connect("body_entered", self, "tent_off")
	$Area2D3.connect("body_entered", self, "tent_off")
	