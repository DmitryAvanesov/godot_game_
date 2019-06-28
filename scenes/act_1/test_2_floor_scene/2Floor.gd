extends Node2D

func _physics_process(delta):
	$Label.rect_scale = Vector2(3, 3)
	$Label.text = str($Enemy.ladderCoordinate)